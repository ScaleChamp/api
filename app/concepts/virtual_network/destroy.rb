class VirtualNetwork::Destroy < ServiceObject
  attr_reader :virtual_network

  def initialize(virtual_network)
    @virtual_network = virtual_network
  end

  def call
    raise StandardError if virtual_network.instances.size > 0
    virtual_network.destroy
  end
end
