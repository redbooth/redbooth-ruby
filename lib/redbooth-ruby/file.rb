module RedboothRuby
  class File < Base
    include RedboothRuby::Operations::Index
    include RedboothRuby::Operations::Create
    include RedboothRuby::Operations::Update
    include RedboothRuby::Operations::Show
    include RedboothRuby::Operations::Delete

    attr_accessor :id,
                  :name,
                  :backend,
                  :project_id,
                  :parent_id,
                  :backend_id,
                  :is_dir,
                  :is_downloadable,
                  :is_previewable,
                  :is_private,
                  :mime_type,
                  :public_token,
                  :pinned,
                  :size,
                  :user_id,
                  :created_at,
                  :updated_at

  class << self
      # Create operation overwrite to parse file first
      def create(attrs)
        super(parse_file(attrs))
      end

      protected

      # Parses the uploaded file to make the correct api request
      #
      # @param attributes [Hash] attributes to parse
      # @return [Hash] parsed attributes hash
      def parse_file(attrs)
        return attrs unless attrs[:asset]
        attrs[:asset_attrs] = {}
        if attrs[:asset].kind_of?(::File) or attrs[:asset].kind_of?(::Tempfile) then
          attrs[:asset_attrs][:name] = attrs[:asset].respond_to?(:original_filename) ? attrs[:asset].original_filename : ::File.basename(attrs[:asset].path)
          attrs[:asset_attrs][:local_path] = attrs[:asset].path
        elsif attrs[:asset].kind_of?(String) then
          attrs[:asset_attrs][:local_path] = attrs[:asset]
          attrs[:asset] = ::File.new(attrs[:file])
          attrs[:asset_attrs][:name] = ::File.basename(attrs[:asset_attrs][:local_path])
        elsif attrs[:asset].kind_of?(StringIO) then
          raise(ArgumentError, "Must specify the :as option when uploading from StringIO") unless attrs[:as]
          attrs[:asset_attrs][:local_path] = attrs[:as]

          # hack for bug in UploadIO
          class << file
            attr_accessor :path
          end
          file.path = attrs[:asset]
        else
          raise ArgumentError, "local_file must be a File, StringIO, or file path"
        end

        attrs[:asset_attrs][:name] = ::File.basename(attrs.delete(:as)) if attrs[:as]

        attrs
      end
    end
  end
end
