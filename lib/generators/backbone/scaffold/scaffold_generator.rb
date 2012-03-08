require 'generators/backbone/helpers'

module Backbone
  module Generators
    class ScaffoldGenerator < Rails::Generators::NamedBase
      include Backbone::Generators::Helpers

      source_root File.expand_path("../templates", __FILE__)

      desc "Generates a Backbone.js resource scaffold"

      class_option :javascript, :type => :boolean, :aliases => "-j", :default => false,
                                :desc => "Generate JavaScript"

      def parse_options
        js = options[:javascript]
        @ext = js ? ".js" : ".js.coffee"
        @jst = js ? ".ejs" : ".eco"
      end

      def create_rails_model
        invoke "#{generator_rails_options[:orm]}:model", name_and_attributes_array
      end

      def create_rails_model_test
        invoke "#{generator_rails_options[:test_framework]}:model", [name]
      end

      def create_rails_route
        # stolen from railties: resource_generator.rb starting on line 18 (add_resource_route)
        route_config =  regular_class_path.collect{|namespace| "namespace :#{namespace} do " }.join(" ")
        route_config << "resources :#{file_name.pluralize}"
        route_config << " end" * regular_class_path.size
        route route_config
      end

      def create_backbone_model
        template "model#{@ext}", File.join(js_path, namespaced_path, "models", "#{file_name.singularize}#{@ext}")
      end

      def create_backbone_model_test
        #template "model_spec#{@ext}", File.join(js_spec_path, namespaced_path, "models", "#{file_name.singularize}_spec#{@ext}")
        template "model_spec#{@ext}", File.join(js_spec_path, namespaced_path, "#{file_name.singularize}_spec#{@ext}")
        #invoke "#{generator_rails_options[:test_framework]}:model", [name]
      end

      def create_backbone_collection
        template "collection#{@ext}",  File.join(js_path, namespaced_path, "collections", "#{file_name.pluralize}#{@ext}")
      end

      def create_backbone_router
        template "router#{@ext}",  File.join(js_path, namespaced_path, "routers", "#{file_name.pluralize}#{@ext}")
      end

      def create_backbone_view
        empty_directory File.join(js_path, namespaced_path, "views", file_name.pluralize)
        template "view#{@ext}",  File.join(js_path, namespaced_path, 'views', file_name.pluralize, "index#{@ext}")
      end

      def create_backbone_template
        empty_directory File.join(template_path, namespaced_path, file_name.pluralize)
        template "template.jst#{@jst}",  File.join(template_path, namespaced_path, file_name.pluralize, "index.jst#{@jst}")
      end
      private

      def name_and_attributes_array
        [name] + attributes.map {|a| "#{a.name}:#{a.type}"}
      end
      
    end
  end
end
