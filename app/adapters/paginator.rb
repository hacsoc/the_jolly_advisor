require 'kaminari'

class Paginator
  def initialize(relation)
    @relation = relation
  end

  delegate :each, to: :@relation

  def page(*args, &block)
    Paginator.new(@relation.page(*args, &block))
  end

  def paginate(view)
    initialize_context(view)
    view.paginate @relation
  end

  def pagination_info(view, *args, &block)
    initialize_context(view)
    view.page_entries_info *([@relation] + args), &block
  end

  private

  def pagination_library
    Kaminari::ActionViewExtension
  end

  def initialize_context(view)
    view.extend pagination_library unless context_initialized?(view)
  end

  def context_initialized?(view)
    view.is_a? pagination_library
  end
end
