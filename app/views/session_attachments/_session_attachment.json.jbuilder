json.extract! session_attachment, :id, :session_id, :image, :created_at, :updated_at
json.url session_attachment_url(session_attachment, format: :json)
