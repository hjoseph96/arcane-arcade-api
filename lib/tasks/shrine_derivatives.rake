namespace :shrine_derivatives do
  desc "Generate shrine derivatives for existing listings"
  task :generate => :environment do
    Listing.pluck(:id).each do |listing_id|
      ShrineCreateDerivativesWorker.perform_async(listing_id)
    end
  end
end
