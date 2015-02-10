class Article < ActiveRecord::Base
  scope :con_nombre_barcode, ->(nombre){where("articles.name ILIKE ? or barcode = ?","#{nombre}%".downcase, nombre)}
  scope :con_nombre, ->(nombre){joins(:supplier).where("LOWER(articles.name) ILIKE ?", "#{nombre}%".downcase) }
  scope :con_id, ->(id){ where('id = ?', "#{id}")}


  has_many :orders
  has_many :stocks
  has_many :deadlines
  belongs_to :category
  belongs_to :supplier

  
  accepts_nested_attributes_for :deadlines, :allow_destroy => true 

  
  
  
  def self.quantity_order(id)
    id.each do |b|
      stock_current = Article.find(b.article_id).quantity
      quantity = b.quantity
      stock_current = 0 if stock_current.nil?
      stock = stock_current - quantity
      Article.find_by_id(b.article_id).update_attribute(:quantity, stock)
    end
  end
  def label
    [barcode, "$ #{price_total}"].compact.join ' | '
  end
  def as_json options = nil
    default_options = { only: [:id, :price_total], methods: [:label] }
    super default_options.merge(options || {})
  end
  def to_s
    name
  end

  def self.current_due_date
    @articles = Deadline.where(due_date: (Time.now.midnight)..(Time.now.midnight + 15.day)).order(due_date: :asc)
  end

end
