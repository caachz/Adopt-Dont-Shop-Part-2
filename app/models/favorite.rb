class Favorite
  attr_reader :contents

  def initialize(initial_contents)
    @contents = initial_contents || Hash.new(0)
  end

  def total_count
    @contents.values.sum
  end

  def add_pet(id)
  @contents[id.to_s] = @contents[id.to_s] + 1
  end

  def favorite_count
    if self.contents == nil
      "0"
    else
      self.contents.values.sum
    end
  end
end
