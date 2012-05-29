require_relative '../renderers/inline_images'

module ShowOff
  module Commands

    class HtmlOutput
      include RenderFromTemplate

      def name
        "html"
      end

      def description
        "This method returns HTML output"
      end

      def generate(options)
        filepath = options['filepath']

        return unless File.exists? filepath

        if File.directory? filepath
          root_path = filepath
          root_node = Parsers::PresentationDirectoryParser.parse filepath, :root_path => ".",
            :showoff_file => (Array(options['showoff_file']) + [ "showoff", "showoff.json" ]).compact.uniq
        else
          root_path = File.dirname filepath
          root_node = Parsers::PresentationFileParser.parse filepath, :root_path => root_path
        end

        root_node.add_post_renderer Renderers::InlineImages

        template_options = {  'erb_template_file' => File.join(default_view_path, "#{options['template']}.erb"),
                              'custom_asset_path' => root_path,
                              'slides' => root_node.to_html }

        render_template template_options
      end

    end

  end
end