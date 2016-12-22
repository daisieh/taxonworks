# A loan item is a CollectionObject, Container, or historical reference to
# something that has been loaned via (Otu)
#
# Thanks to https://neanderslob.com/2015/11/03/polymorphic-associations-the-smart-way-using-global-ids/ for global_entity.
#
#
# @!attribute loan_id
#   @return [Integer]
#   Id of the loan
#
# @!attribute loan_object_type
#   @return [String]
#   Polymorphic- one of Container, CollectionObject, or Otu
#
# @!attribute loan_object_id
#   @return [Integer]
#   Polymorphic, the id of the Container, CollectionObject or Otu
#
# @!attribute date_returned
#   @return [DateTime]
#   The date the item was returned.
#
# @!attribute disposition
#   @return [String]
#     an evolving controlled vocabulary used to differentiate loan object status when it differs from that of the overal loan, see LoanItem::STATUS
#
# @!attribute position
#   @return [Integer]
#    Sorts the items in relation to the loan.
#
# @!attribute project_id
#   @return [Integer]
#   the project ID
#
# @!attribute total
#   @return [Integer]
#     when type is OTU an arbitrary total can be provided
#
class LoanItem < ApplicationRecord
  acts_as_list scope: :loan

  include Housekeeping
  include Shared::IsData
  include Shared::DataAttributes
  include Shared::Notable
  include Shared::Taggable

  attr_accessor :date_returned_jquery

  STATUS = ['Destroyed', 'Donated', 'Loaned on', 'Lost', 'Retained', 'Returned']

  belongs_to :loan
  belongs_to :loan_item_object, polymorphic: true

  validates_presence_of :loan_item_object_id, :loan_item_object_type

  validates :loan_id, presence: true
  validates_uniqueness_of :loan, scope: [:loan_item_object_type, :loan_item_object_id]

  validate :total_provided_only_when_otu
  validate :loan_object_is_loanable

  validates_inclusion_of :disposition, in: STATUS, if: '!disposition.blank?'

  def global_entity
    self.loan_item_object.to_global_id if self.loan_item_object.present?
  end

  def global_entity=(entity)
    self.loan_item_object = GlobalID::Locator.locate entity
  end

  def date_returned_jquery=(date)
    self.date_returned = date.gsub(/(\d+)\/(\d+)\/(\d+)/, '\2/\1/\3')
  end

  def date_returned_jquery
    self.date_returned
  end

  def returned?
    !date_returned.blank?
  end

  # @return [Integer, nil]
  #   the total items this loan line item represent
  # TODO: this does not factor in nested items in a container
  def total_items
    case loan_item_object_type
      when 'Otu'
        total ? total : nil
      when 'Container'
        loan_item_object.container_items.try(:count)
      when 'CollectionObject'
        loan_item_object.total.to_i
      else
        nil
    end
  end

  # @return [Array]
  #   all objects that can have a taxon determination applied to them for htis loan item
  def determinable_objects
    # this loan item which may be a container, an OTU, or a collection object
    case loan_item_object_type
    when /contain/i # if this item is a container, dig into the container for the collection objects themselves
      loan_item_object.collection_objects
    when /object/i # if this item is a collection object, just add the object
      [loan_item_object]
    when /otu/i # not strictly needed, but helps keep track of what the loan_item is.
      [] # can't use an OTU as a determination object.
    end
  end

  # @params :ids -> an ID of a loan_item
  def self.batch_determine_loan_items(ids: [], params: {})
    return false if ids.empty?
    # these objects will be created/persisted to be used for each of the loan items identified by the input ids
    td = TaxonDetermination.new(params) # build a td from the input data

    begin
      LoanItem.transaction do
        item_list = [] # Array of objects that can have a taxon determination
        LoanItem.where(id: ids).each do |li|
          item_list.push li.determinable_objects
        end

        item_list.flatten!

        first = item_list.pop
        td.biological_collection_object = first
        td.save! # create and save the first one so we can dup it in the next step

        item_list.each do |item|
          n = td.dup
          n.determiners << td.determiners
          n.biological_collection_object = item
          n.save
          n.move_to_top
        end
      end
    rescue ActiveRecord::RecordInvalid
      return false
    end
    true
  end

  protected

  def total_provided_only_when_otu
    errors.add(:total, 'only providable when item is an OTU.') if total && loan_item_object_type != 'Otu'
  end

  def loan_object_is_loanable
    loan_item_object && loan_item_object.respond_to?(:loanable?)
  end

end
