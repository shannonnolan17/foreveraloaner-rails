class Post < ApplicationRecord
	belongs_to 	:loaner, class_name: "User"
	belongs_to 	:category

	has_many  	:post_tags
	has_many	  :tags, through: :post_tags
  has_many 	  :transactions

	validates 	:title, :description, :price, :status, :loaner_id, :category_id, :status, presence: true
  
  #the validation below is neccessary because false values do not pass validation tests
  validates_inclusion_of :negotiable, in: [true, false]

  #paperclip
  has_attached_file :image, styles: {large: "600x600>", medium: "300x300>", thumb:"150x150#"}, default_url: "no_image_available.png"
  validates_attachment_content_type :image, content_type: ["image/jpeg", "image/gif", "image/png"]

  #search bar
  def self.search(search_term)
    by_tag = self.joins(:tags).where('lower(name) LIKE ?', "%#{search_term.downcase}%" ).distinct
    by_title = self.where('lower(title) LIKE ?', "%#{search_term.downcase}%").order('id DESC')
    return (by_tag | by_title).uniq
  end


end
