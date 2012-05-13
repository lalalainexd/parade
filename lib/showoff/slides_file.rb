require_relative "renderers/html_with_pygments"
require_relative 'slide'
require_relative 'parsers/markdown_slide_splitter'
require_relative 'parsers/markdown_image_paths'

module ShowOff

  #
  # A markdown file on the file system usually contains many slides separated
  # by the special slide delimiter.
  #
  class SlidesFile

    # The filepath of the particular slide file. This is useful for building
    # the correct file path to any referenced files (e.g. images) within the
    # markdown file.
    attr_accessor :filepath

    # The section which this slides file belongs
    attr_accessor :section

    def initialize(params = {})
      params.each {|k,v| send("#{k}=",v) if respond_to? "#{k}=" }
    end

    # @return [String] if the filepath is a folder then this returns itself
    #   if it is a file then it returns the directory name.
    def rootpath
      File.directory?(filepath) ? filepath : File.dirname(filepath)
    end

    # @return [String] the contents of the markdown file
    def markdown_content
      File.read(filepath)
    end

    #
    # The original markdown content that is split and formatted into slides.
    #
    # @return [Array<Slide>] an array of Slide objects that have been parsed
    #   from the markdown content.
    def to_slides
      content = Parsers::MarkdownImagePaths.parse(markdown_content,:path => rootpath.gsub(section.presentation.filepath,''))
      slides = Parsers::MarkdownSlideSplitter.parse(content)
      slides
    end
    
    alias_method :slides, :to_slides

  end
end