class ImageUploader < Shrine
  Attacher.derivatives do |original|
    magick = ImageProcessing::MiniMagick.source(original).loader(page: 0).convert('jpg')

    { 
      small:  magick.resize_to_fill!(400, 400),
      large:  magick.resize_to_fill!(1920, 1080),
    }
  end
end
