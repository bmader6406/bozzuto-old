class PropertyFeedImport < ActiveRecord::Base
  # disable STI on `type` field
  self.inheritance_column = nil

  STATES = %w(queued processing success failure)

  has_attached_file :file,
                    url: '/system/:class/:id/:filename'

  validates :type,
            presence: true

  validates :state,
            allow_blank: false,
            inclusion: {
              in: STATES
            }

  validates_attachment :file,
                       presence: true,
                       content_type: {
                         content_type: [
                           "text/xml",
                           "application/xml"
                         ]
                       }

  before_validation :set_queued, if: :blank_state?

  scope :psi, -> { where(type: "psi").order(created_at: :desc) }

  def mark_as_queued
    update_attributes(
      state:       "queued",
      started_at:  nil,
      finished_at: nil
    )
  end

  def mark_as_processing
    update_attributes(
      state:      "processing",
      started_at: Time.now
    )
  end

  def mark_as_success
    update_attributes(
      state:       "success",
      finished_at: Time.now
    )
  end

  def mark_as_failure(err = nil)
    update_attributes(
      state:       "failure",
      error:       err.to_s,
      finished_at: Time.now
    )
  end

  private

  def set_queued
    self.state = "queued"
  end

  def blank_state?
    state.blank?
  end
end
