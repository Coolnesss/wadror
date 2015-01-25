class AddSiteLinksToBreweries < ActiveRecord::Migration
  def change
	add_column :breweries, :site_link, :string
  end
end
