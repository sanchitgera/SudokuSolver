require 'Matrix'

class BetterMatrix < Matrix
  public :"[]=", :set_element, :set_component
end
