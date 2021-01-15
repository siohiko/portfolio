class ApplicationNotice < Notice
  validates :applicant_id,  presence: true
  validates :recruiting_id,  presence: true
end