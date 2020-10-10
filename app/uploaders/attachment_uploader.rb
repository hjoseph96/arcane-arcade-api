class AttachmentUploader < Shrine
  plugin :backgrounding

  Attacher.promote_block do
    attacher_class = Object.const_get(self.class.name)
    found_record         = Object.const_get(self.record.class.name).find(self.record.id) # if using Active Record

    attacher = attacher_class.retrieve(model: found_record, name: self.name, file: self.file_data)

    old_id = found_record.attachment.id

    attacher.atomic_promote

    found_record.update_trix_attachment(old_id)
  end
  Attacher.destroy_block do
    attacher_class = Object.const_get(self.class.name)

    attacher = attacher_class.from_data(self.data)
    attacher.destroy
  end
end
