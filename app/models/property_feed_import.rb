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
                           "text/plain",
                           "text/xml",
                           "application/xml"
                         ]
                       }

  before_validation :set_queued, if: :blank_state?

  Bozzuto::ExternalFeed::SOURCES.each do |source|
    scope source, -> { where(type: source).order(created_at: :desc) }
  end

  STATES.each do |state|
    define_method "#{state}?" do
      self.state == state
    end
  end

  def mark_as_queued!
    update_attributes(
      state:       "queued",
      started_at:  nil,
      finished_at: nil
    )
  end

  def mark_as_processing!
    update_attributes(
      state:      "processing",
      started_at: Time.now
    )
  end

  def mark_as_success!
    update_attributes(
      state:       "success",
      finished_at: Time.now
    )
  end

  def mark_as_failure!(err = nil)
    update_attributes(
      state:       "failure",
      error:       err ? err.to_s : nil,
      stack_trace: err ? err.backtrace : nil,
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
