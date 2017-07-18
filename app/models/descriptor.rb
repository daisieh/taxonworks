class Descriptor < ActiveRecord::Base
  include Housekeeping
  include Shared::Citable              
  include Shared::Identifiable
  include Shared::IsData
  include Shared::Taggable
  include Shared::Notable
  include Shared::DataAttributes
  include Shared::AlternateValues
  include Shared::Confidence
  include Shared::Documentation
  include SoftValidation

  acts_as_list scope: [:project_id]

  ALTERNATE_VALUES_FOR = [:name, :short_name]

  validates_presence_of :name, :type
  validate :type_is_subclassed
  validate :short_name_is_shorter

  has_many :observations, inverse_of: :descriptor, dependent: :restrict_with_error
  has_many :otus, through: :observations, inverse_of: :descriptors

  soft_validate(:sv_short_name_is_short)

  def self.human_name
    self.name.demodulize.humanize
  end

  def qualitative?
    type == 'Descriptor::Qualitative'
  end
  protected

  def type_is_subclassed
    if !DESCRIPTOR_TYPES[type]
      errors.add(:type, 'type must be a valid subclass')
    end
  end

  def short_name_is_shorter
    errors.add(:short_name, 'is longer than name!') if short_name && name && (short_name.length > name.length)
  end

  def sv_short_name_is_short
    soft_validations.add(:short_name, 'should likely be less than 12 characters long') if short_name && short_name.length > 12
  end

end

Dir[Rails.root.to_s + '/app/models/descriptor/**/*.rb'].each { |file| require_dependency file }