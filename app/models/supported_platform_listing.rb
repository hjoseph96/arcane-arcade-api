class SupportedPlatformListing < ApplicationRecord
  SYSTEM_REQUIREMENTS_KEYS = ["os", "processor", "memory", "graphics", "storage"]
  WINDOWS_SYSTEM_REQUIREMENTS_KEYS = SYSTEM_REQUIREMENTS_KEYS + ["directX"]

  belongs_to :listing
  belongs_to :supported_platform
  has_one :distribution, dependent: :destroy

  validate :minimum_system_requirements

  accepts_nested_attributes_for :distribution, update_only: true

  private

  def minimum_system_requirements
    # validate only platforms which are childs of PC platform
    if self.supported_platform&.parent&.name == "PC"
      error_message = "Please fill in all the fields for minimum #{self.supported_platform.name} System Requirements"
      unless self.system_requirements.present?
        self.listing.errors.add(:base, error_message)
        return
      end
      if !self.system_requirements["minimum"].present? || !self.system_requirements["recommended"].present?
        self.listing.errors.add(:base, error_message)
        return
      end
      minimum = self.system_requirements["minimum"]
      keys = self.supported_platform.name == "WINDOWS" ? WINDOWS_SYSTEM_REQUIREMENTS_KEYS : SYSTEM_REQUIREMENTS_KEYS
      empty_keys = []
      keys.each do |key|
        if !minimum[key].present?
          empty_keys.push(key)
        end
      end
      if empty_keys.any?
        self.listing.errors.add(:base, "Fields #{empty_keys.map(&:titleize).join(', ')} for minimum requirement on #{self.supported_platform.name} platform can't be blank")
      end
    end
  end
end
