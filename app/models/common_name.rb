class CommonName < ApplicationRecord
  include Housekeeping
  include Shared::AlternateValues 
  include Shared::Citable         
  include Shared::DataAttributes
  include Shared::Identifiable
  include Shared::Notable
  include Shared::Taggable
  include Shared::IsData

  ALTERNATE_VALUES_FOR = [:name]

  belongs_to :geographic_area
  belongs_to :otu
  belongs_to :language

  has_one :taxon_name, through: :otu

  validates_presence_of :name
  validates_presence_of :otu_id

  validates :start_year,
    numericality: {only_integer: true,
                   greater_than: -2500,
                   less_than:    (Time.now.year + 5),
                   message:      'start date year must be an integer greater than 1500, and no more than 5 years in the future'},
                   length:       {is: 4},
                   allow_nil:    true

  validates :end_year,
    numericality: {only_integer: true,
                   greater_than: -2500,
                   less_than:    (Time.now.year + 5),
                   message:      'start date year must be an integer greater than 1500, and no more than 5 years in the future'},
                   length:       {is: 4},
                   allow_nil:    true

end
