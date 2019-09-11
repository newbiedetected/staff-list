require "administrate/base_dashboard"

class MaterialDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    name: Field::String,
    material_type: Field::Select.with_options(
      collection: ['Hardware', 'Software', 'Peripheral']
    ),
    status: Field::Select.with_options(
      collection: ['Deployed', 'Stored', 'Defective']
    ),
    employee: Field::BelongsTo,
    # employee: Field::Hidden.with_options(
    #   value: nil
    # ),
    # employee: Field::Select.with_options(
    #   collection: [0]
    # ),
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :id,
    :name,
    :material_type,
    :employee,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :id,
    :name,
    :material_type,
    :status,
    :employee,
    :created_at,
    :updated_at,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :name,
    :material_type,
    :status,
    :employee,
  ].freeze

  # Overwrite this method to customize how materials are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(material)
    "#{material.name}"
  end
end