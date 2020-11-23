class ShrinePromoteWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'shrine'

  def perform(attacher_class, record_class, record_id, name, file_data)
    attacher_class = Object.const_get(attacher_class)
    record         = Object.const_get(record_class).find(record_id) # if using Active Record 
 
    attacher = attacher_class.retrieve(model: record, name: name, file: file_data)

    old_attachment_id = record.send(name).id

    attacher.create_derivatives

    attacher.atomic_promote

    if record.respond_to? :after_shrine_promote
      record.after_shrine_promote(old_attachment_id)
    end
  rescue Shrine::AttachmentChanged, ActiveRecord::RecordNotFound
    # attachment has changed or record has been deleted, nothing to do 
  end
end
