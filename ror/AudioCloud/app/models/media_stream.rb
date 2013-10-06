class MediaStream < ActiveRecord::Base

	validates :name, :permalink_url, :url, :media_type, presence: true
	validates :name, length: {
		minimum: 1,
		maximum: 142,
		too_short: "must have at least %{count} words",
		too_long: "must have at most %{count} words"
	}


end
