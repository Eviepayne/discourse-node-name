# name: discourse-node-name
# about: Display the web-node you are connected to in a clustered environment
# version: 0.1
# authors: vladtheimplier

# Install this theme component
# api.onPageChange(async () => {
#   const isAdmin = window.location.pathname.startsWith("/admin");
#   const existing = document.getElementById("discourse-node-info");
#
#   if (isAdmin) {
#     if (!existing) {
#       const nodeName = await getNodeName();
#       const nodeInfo = document.createElement("div");
#       nodeInfo.id = "discourse-node-info";
#       nodeInfo.className = "alert alert-info";
#       nodeInfo.style.position = "fixed";
#       nodeInfo.style.bottom = "1em";
#       nodeInfo.style.right = "1em";
#       nodeInfo.style.zIndex = "10000";
#       nodeInfo.style.maxWidth = "300px";
#
#       nodeInfo.textContent = `Node: ${nodeName}`;
#       document.body.appendChild(nodeInfo);
#     }
#   } else {
#     if (existing) {
#       existing.remove();
#     }
#   }
# });

after_initialize do
  module ::DiscourseNodeInfo
    class Engine < ::Rails::Engine
      engine_name "discourse_node_info"
      isolate_namespace DiscourseNodeInfo
    end
  end

  class ::DiscourseNodeInfo::NodeController < ::ApplicationController
    skip_before_action :check_xhr
    skip_before_action :verify_authenticity_token

    def show
      render json: { node: ENV["HOSTNAME"] || `hostname`.strip }
    end
  end

  DiscourseNodeInfo::Engine.routes.draw do
    get "/" => "node#show"
  end

  Discourse::Application.routes.append do
    mount ::DiscourseNodeInfo::Engine, at: "/node-info"
  end
end
