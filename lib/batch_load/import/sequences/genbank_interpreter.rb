# TODO: THIS IS A GENERATED STUB, it does not function
module BatchLoad
  class Import::Sequences::GenbankInterpreter < BatchLoad::Import

    def initialize(**args)
      @foos = {}
      super(args)
    end

    # TODO: update this
    def build_foos

      i = 1
      # loop throw rows
      csv.each do |row|

        parse_result = BatchLoad::RowParse.new
        parse_result.objects[:foo] = []

        @processed_rows[i] = parse_result

        begin # processing
           # use a BatchLoad::ColumnResolver or other method to match row data to TW 
           #  ...
        #rescue
           # ....
        end
        i += 1
      end
    end

    def build
      if valid?
        build_foos
        @processed = true
      end
    end

  end
end
