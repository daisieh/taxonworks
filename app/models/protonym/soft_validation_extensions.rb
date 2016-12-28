module Protonym::SoftValidationExtensions

  module Klass

    VALIDATIONS = {
      sv_validate_parent_rank: {
        set: :validate_parent_rank,
        resolution: [],
        name: 'Validate parent rank',
        description: 'Validates parent rank.' 
      },

      sv_missing_relationships: { set: :missing_relationships},
      sv_missing_classifications: { set: :missing_classifications},
      sv_species_gender_agreement: { set: :species_gender_agreement},
      sv_type_placement: { set: :type_placement},
      sv_primary_types: { set: :primary_types},
      sv_validate_coordinated_names: { set: :validate_coordinated_names},
      sv_single_sub_taxon: { set: :single_sub_taxon},
      sv_parent_priority: { set: :parent_priority},
      sv_homotypic_synonyms: { set: :homotypic_synonyms},
      sv_potential_homonyms: { set: :potential_homonyms},
      sv_source_not_older_then_description: { set: :dates},
      sv_original_combination_relationships: { set: :original_combination_relationships},
      sv_extant_children: { set: :extant_children}
    }

    VALIDATIONS.keys.each do |k|
      Protonym.soft_validate(k, VALIDATIONS[k])
    end
  end
  
  module Instance 
   
    def sv_source_not_older_then_description
      if self.source && self.year_of_publication
        soft_validations.add(:base, 'The year of publication and the year of reference do not match') if self.try(:source).try(:year) != self.year_of_publication
      end
    end

    def sv_validate_parent_rank
      if self.rank_class
        if rank_string == 'NomenclaturalRank' || self.parent.rank_string == 'NomenclaturalRank' || !!self.iczn_uncertain_placement_relationship
          true
        elsif !self.rank_class.valid_parents.include?(self.parent.rank_string)
          soft_validations.add(:rank_class, "The rank #{self.rank_class.rank_name} is not compatible with the rank of parent (#{self.parent.rank_class.rank_name}). The name should be marked as Incertae sedis", resolution: 'path_to_edit_protomy')
        end
      end
    end

    def sv_missing_relationships
      if is_species_rank? 
        soft_validations.add(:base, 'Original genus is not selected') if self.original_genus.nil?
      elsif is_genus_rank? 
        soft_validations.add(:base, 'Type species is not selected') if self.type_species.nil?
      elsif is_family_rank? 
        soft_validations.add(:base, 'Type genus is not selected') if self.type_genus.nil?
      end
      if !self.iczn_set_as_homonym_of.nil? || !TaxonNameClassification.where_taxon_name(self).with_type_string('TaxonNameClassification::Iczn::Available::Invalid::Homonym').empty?
        soft_validations.add(:base, 'The replacement name for the homonym is not selected') if self.iczn_set_as_synonym_of.nil?
      end
    end

    def sv_missing_classifications
      if is_species_rank?
        soft_validations.add(:base, 'Part of speech is not specified') if self.part_of_speech_class.nil?
      elsif is_genus_rank? 
        if self.gender_class.nil?
          g = genus_suggested_gender
          soft_validations.add(:base, "Gender is not specified#{ g.nil? ? '' : ' (possible gender is ' + g + ')'}")
        end
      end
    end

    def sv_species_gender_agreement
      if is_species_rank? 
        s = self.part_of_speech_name
        unless self.part_of_speech_name.nil?
          if s =~ /(adjective|participle)/

            if self.feminine_name.blank?
              soft_validations.add(:feminine_name, 'Spelling in feminine is not provided')
            else
              e = species_questionable_ending(TaxonNameClassification::Latinized::Gender::Feminine, self.feminine_name)
              unless e.nil?
                soft_validations.add(:feminine_name, "Name has non feminine ending: -#{e}")
              end
            end

            if self.masculine_name.blank?
              soft_validations.add(:masculine_name, 'Spelling in masculine is not provided')
            else
              e = species_questionable_ending(TaxonNameClassification::Latinized::Gender::Masculine, self.masculine_name)
              unless e.nil?
                soft_validations.add(:masculine_name, "Name has non masculine ending: -#{e}")
              end
            end

            if self.neuter_name.blank?
              soft_validations.add(:neuter_name, 'Spelling in neuter is not provided')
            else
              e = species_questionable_ending(TaxonNameClassification::Latinized::Gender::Neuter, self.neuter_name)
              unless e.nil?
                soft_validations.add(:neuter_name, "Name has non neuter ending: -#{e}")
              end
            end

            if self.masculine_name.blank? && self.feminine_name.blank? && self.neuter_name.blank?
              g = self.ancestor_at_rank('genus').gender_class
              unless g.nil?
                e = species_questionable_ending(g, self.name)
                unless e.nil?
                  soft_validations.add(:name, "Name has non #{g.class_name} ending: -#{e}")
                end
              end
            end

          else

            soft_validations.add(:feminine_name, 'Alternative spelling is not required for the name being noun') unless self.feminine_name.blank?
            soft_validations.add(:masculine_name, 'Alternative spelling is not required for the name being noun')  unless self.masculine_name.blank?
            soft_validations.add(:neuter_name, 'Alternative spelling is not required for the name being noun')  unless self.neuter_name.blank?

          end
        end
      end
    end

    # !! TODO: @proceps - make these individual validations !! way too complex here
    def sv_validate_coordinated_names
      list_of_coordinated_names.each do |t|
        soft_validations.add(:base, "The source does not match with the source of the coordinated #{t.rank_class.rank_name}",
                             fix: :sv_fix_coordinated_names, success_message: 'Source was updated') unless (self.source && t.source) && (self.source.id == t.source.id)
        soft_validations.add(:verbatim_author, "The author does not match with the author of the coordinated #{t.rank_class.rank_name}",
                             fix: :sv_fix_coordinated_names, success_message: 'Author was updated') unless self.verbatim_author == t.verbatim_author
        soft_validations.add(:year_of_publication, "The year does not match with the year of the coordinated #{t.rank_class.rank_name}",
                             fix: :sv_fix_coordinated_names, success_message: 'Year was updated') unless self.year_of_publication == t.year_of_publication
        soft_validations.add(:base, "The gender does not match with the gender of the coordinated #{t.rank_class.rank_name}",
                             fix: :sv_fix_coordinated_names, success_message: 'Gender was updated') if rank_string =~ /Genus/ && self.gender_class != t.gender_class
        soft_validations.add(:base, "The part of speech does not match with the part of speech of the coordinated #{t.rank_class.rank_name}",
                             fix: :sv_fix_coordinated_names, success_message: 'Gender was updated') if rank_string =~ /Species/ && self.part_of_speech_class != t.part_of_speech_class
        soft_validations.add(:base, "The original genus does not match with the original genus of coordinated #{t.rank_class.rank_name}",
                             fix: :sv_fix_coordinated_names, success_message: 'Original genus was updated') unless self.original_genus == t.original_genus
        soft_validations.add(:base, "The original subgenus does not match with the original subgenus of the coordinated #{t.rank_class.rank_name}",
                             fix: :sv_fix_coordinated_names, success_message: 'Original subgenus was updated') unless self.original_subgenus == t.original_subgenus
        soft_validations.add(:base, "The original species does not match with the original species of the coordinated #{t.rank_class.rank_name}",
                             fix: :sv_fix_coordinated_names, success_message: 'Original species was updated') unless self.original_species == t.original_species
        soft_validations.add(:base, "The type species does not match with the type species of the coordinated #{t.rank_class.rank_name}",
                             fix: :sv_fix_coordinated_names, success_message: 'Type species was updated') unless self.type_species == t.type_species
        soft_validations.add(:base, "The type genus does not match with the type genus of the coordinated #{t.rank_class.rank_name}",
                             fix: :sv_fix_coordinated_names, success_message: 'Type genus was updated') unless self.type_genus == t.type_genus
        soft_validations.add(:base, "The type specimen does not match with the type specimen of the coordinated #{t.rank_class.rank_name}",
                             fix: :sv_fix_coordinated_names, success_message: 'Type specimen was updated') unless self.has_same_primary_type(t)
        sttnr = self.type_taxon_name_relationship
        tttnr = t.type_taxon_name_relationship
        unless sttnr.nil? || tttnr.nil?
          soft_validations.add(:base, "The type species relationship does not match with the relationship of the coordinated #{t.rank_class.rank_name}",
                               fix: :sv_fix_coordinated_names, success_message: 'Type genus was updated') unless sttnr.type == tttnr.type
        end
      end

    end

    # TODO: way too long 
    def sv_fix_coordinated_names
      fixed = false
      gender = self.gender_class
      speech = self.part_of_speech_class

      list_of_coordinated_names.each do |t|
        if t.source && (source != t.source) 
          self.source = t.source
          fixed = true
        end

        if self.verbatim_author.nil? && self.verbatim_author != t.verbatim_author
          self.verbatim_author = t.verbatim_author
          fixed = true
        end

        if self.year_of_publication.nil? && !t.year_of_publication.nil?
          self.year_of_publication = t.year_of_publication
          fixed = true
        end

        t_gender = t.gender_class

        if gender.nil? && gender != t_gender
          self.TaxonNameClassification.build(type: t_gender.to_s)
          fixed = true
        end

        t_speech = t.part_of_speech_class

        if speech.nil? && speech != t_speech
          self.TaxonNameClassification.build(type: t_speech.to_s)
          fixed = true
        end

        if self.gender_class.nil? && !t.gender_class.nil?
          self.taxon_name_classification.build(type: t.gender_name)
          fixed = true
        end

        if self.original_genus.nil? && !t.original_genus.nil?
          self.original_genus = t.original_genus
          fixed = true
        end

        if self.original_subgenus.nil? && !t.original_subgenus.nil?
          self.original_subgenus = t.original_subgenus
          fixed = true
        end

        if self.original_species.nil? && !t.original_species.nil?
          self.original_species = t.original_species
          fixed = true
        end

        if self.original_subspecies.nil? && !t.original_subspecies.nil?
          self.original_subspecies = t.original_subspecies
          fixed = true
        end

        if self.type_species.nil? && !t.type_species.nil?
          self.type_species = t.type_species
          fixed = true
        end

        if self.type_genus.nil? && !t.type_genus.nil?
          self.type_genus = t.type_genus
          fixed = true
        end

        types1 = self.get_primary_type
        types2 = t.get_primary_type
        if types1.empty? && !types2.empty?
          new_type_material = []
          types2.each do |t|
            new_type_material.push({type_type: t.type_type, protonym_id: t.protonym_id, biological_object_id: t.biological_object_id, source: t.source})
          end
          self.type_materials.build(new_type_material)
          fixed = true
        end

        sttnr = self.type_taxon_name_relationship
        tttnr = t.type_taxon_name_relationship
        unless sttnr.nil? || tttnr.nil?
          if sttnr.type != tttnr.type && sttnr.type.safe_constantize.descendants.collect{|i| i.to_s}.include?(tttnr.type.to_s)
            self.type_taxon_name_relationship.type = t.type_taxon_name_relationship.type
            fixed = true
          end
        end
      end

      if fixed
        begin
          Protonym.transaction do
            self.save
          end
        rescue
          return false
        end
      end
      return fixed
    end

    def sv_type_placement
      # type of this taxon is not included in this taxon
      if !!self.type_taxon_name
        soft_validations.add(:base, "The type should be included in this #{self.rank_class.rank_name}") unless self.type_taxon_name.get_valid_taxon_name.ancestors.include?(self.get_valid_taxon_name)
      end
      # this taxon is a type, but not included in nominal taxon
      if !!self.type_of_taxon_names
        self.type_of_taxon_names.find_each do |t|
          soft_validations.add(:base, "This taxon is type of #{t.rank_class.rank_name} #{t.name} but is not included there") unless self.get_valid_taxon_name.ancestors.include?(t.get_valid_taxon_name)
        end
      end
    end

    def sv_primary_types
      if self.rank_class
        if self.rank_class.parent.to_s =~ /Species/
          if self.type_materials.primary.empty? && self.type_materials.syntypes.empty?
            soft_validations.add(:base, 'Primary type is not selected')
          elsif self.type_materials.primary.count > 1 || (!self.type_materials.primary.empty? && !self.type_materials.syntypes.empty?)
            soft_validations.add(:base, 'More than one primary type are selected')
          end
        end
      end
    end

    def sv_single_sub_taxon
      if self.rank_class
        rank = rank_string 
        if rank != 'potentially_validating rank' && self.rank_class.nomenclatural_code == :iczn && %w(subspecies subgenus subtribe tribe subfamily).include?(self.rank_class.rank_name)
          sisters = self.parent.descendants.with_rank_class(rank)
          if rank =~ /Family/
            z = Protonym.family_group_base(self.name)
            search_name = z.nil? ? nil : Protonym::FAMILY_GROUP_ENDINGS.collect{|i| z+i}
            a = sisters.collect{|i| Protonym.family_group_base(i.name) }
            sister_names = a.collect{|z| Protonym::FAMILY_GROUP_ENDINGS.collect{|i| z+i} }.flatten
          else
            search_name = [self.name]
            sister_names = sisters.collect{|i| i.name }
          end
          if search_name.include?(self.parent.name) && sisters.count == 1
            soft_validations.add(:base, "This taxon is a single #{self.rank_class.rank_name} in the nominal #{self.parent.rank_class.rank_name}")
          elsif !sister_names.include?(self.parent.name)
            soft_validations.add(:base, "The parent #{self.parent.rank_class.rank_name} of this #{self.rank_class.rank_name} does not contain nominotypical #{self.rank_class.rank_name}",
                                 fix: :sv_fix_add_nominotypical_sub, success_message: "Nominotypical #{self.rank_class.rank_name} was added to nominal #{self.parent.rank_class.rank_name}")
          end
        end
      end
    end

    def sv_fix_add_nominotypical_sub
      rank = rank_string 
      p = self.parent
      prank = p.rank_string
      if (rank =~ /Family/ && prank =~ /Family/) || (rank =~ /Genus/ && prank =~ /Genus/) || (rank =~ /Species/ && prank =~ /Species/)
        begin
          Protonym.transaction do
            if rank =~ /Family/ && prank =~ /Family/
              name = Protonym.family_group_base(self.parent.name)
              case self.rank_class.rank_name
              when 'subfamily'
                name += 'inae'
              when 'tribe'
                name += 'ini'
              when 'subtribe'
                name += 'ina'
              end
            else
              name = p.name
            end

            t = Protonym.new(name: name, rank_class: rank, verbatim_author: p.verbatim_author, year_of_publication: p.year_of_publication, source: p.source, parent: p)
            t.save
            t.soft_validate
            t.fix_soft_validations
            return true
          end
        rescue ActiveRecord::RecordInvalid # naked rescue is very bad
          return false
        end
      end
    end

    def sv_parent_priority
      if self.rank_class
        rank_group = self.rank_class.parent
        parent = self.parent

        if parent && rank_group == parent.rank_class.parent
          unless self.unavailable_or_invalid?
            date1 = self.nomenclature_date
            date2 = parent.nomenclature_date
            unless date1.nil? || date2.nil?
              if date1 < date2
                soft_validations.add(:base, "#{self.rank_class.rank_name.capitalize} should not be older than parent #{parent.rank_class.rank_name}")
              end
            end
          end
        end
      end
    end

    def sv_homotypic_synonyms
      unless self.unavailable_or_invalid?
        if self.id == self.lowest_rank_coordinated_taxon.id
          possible_synonyms = []
          if rank_string =~ /Species/
            primary_types = self.get_primary_type
            unless primary_types.empty?
              p = primary_types.collect{|t| t.biological_object_id}
              possible_synonyms = Protonym.with_type_material_array(p).that_is_valid.without_taxon_name_classification_array(TAXON_NAME_CLASS_NAMES_UNAVAILABLE_AND_INVALID).not_self(self).with_project(self.project_id)
            end
          else
            type = self.type_taxon_name
            unless type.nil?
              possible_synonyms = Protonym.with_type_of_taxon_names(type.id).that_is_valid.not_self(self).with_project(self.project_id)
            end
          end

          possible_synonyms = reduce_list_of_synonyms(possible_synonyms)

          possible_synonyms.each do |s|
            soft_validations.add(:base, "Taxon should be a synonym of #{s.cached_html} #{s.cached_author_year} since they share the same type")
          end
        end
      end
    end


    def sv_potential_homonyms
      if self.parent
        unless classification_invalid_or_unavailable? || !Protonym.with_taxon_name_relationships_as_subject.with_homonym_or_suppressed.empty? #  self.unavailable_or_invalid?
          if self.id == self.lowest_rank_coordinated_taxon.id
            rank_base = self.rank_class.parent.to_s
            name1 = self.cached_primary_homonym ? self.cached_primary_homonym : nil
            possible_primary_homonyms = name1 ? Protonym.with_primary_homonym(name1).without_taxon_name_classification_array(TAXON_NAME_CLASS_NAMES_UNAVAILABLE_AND_INVALID).without_homonym_or_suppressed.not_self(self).with_base_of_rank_class(rank_base).with_project(self.project_id) : []
            list1 = reduce_list_of_synonyms(possible_primary_homonyms)
            if !list1.empty?
              list1.each do |s|
                if rank_base =~ /Species/
                  soft_validations.add(:base, "Taxon should be a primary homonym of #{s.cached_name_and_author_year}")
                  #  fix: :sv_fix_add_relationship('iczn_set_as_primary_homonym_of'.to_sym, s.id),
                  #  success_message: 'Primary homonym relationship was added',
                  #  failure_message: 'Fail to add a relationship')
                elsif
                  soft_validations.add(:base, "Taxon should be an homonym of #{s.cached_name_and_author_year}")
                end
              end
            else
              name2 = self.cached_primary_homonym_alternative_spelling ? self.cached_primary_homonym_alternative_spelling : nil
              possible_primary_homonyms_alternative_spelling = name2 ? Protonym.with_primary_homonym_alternative_spelling(name2).without_homonym_or_suppressed.without_taxon_name_classification_array(TAXON_NAME_CLASS_NAMES_UNAVAILABLE_AND_INVALID).not_self(self).with_base_of_rank_class(rank_base).with_project(self.project_id) : []
              list2 = reduce_list_of_synonyms(possible_primary_homonyms_alternative_spelling)
              if !list2.empty?
                list2.each do |s|
                  if rank_base =~ /Species/
                    soft_validations.add(:base, "Taxon could be a primary homonym of #{s.cached_name_and_author_year} (alternative spelling)")
                  elsif
                    soft_validations.add(:base, "Taxon could be an homonym of #{s.cached_name_and_author_year} (alternative spelling)")
                  end
                end
              elsif rank_base =~ /Species/
                name3 = self.cached_secondary_homonym ? self.cached_secondary_homonym : nil
                possible_secondary_homonyms = name3 ? Protonym.with_secondary_homonym(name3).without_homonym_or_suppressed.without_taxon_name_classification_array(TAXON_NAME_CLASS_NAMES_UNAVAILABLE_AND_INVALID).not_self(self).with_base_of_rank_class(rank_base).with_project(self.project_id) : []
                list3 = reduce_list_of_synonyms(possible_secondary_homonyms)
                if !list3.empty?
                  list3.each do |s|
                    soft_validations.add(:base, "Taxon should be a secondary homonym of #{s.cached_name_and_author_year}")
                  end
                else
                  name4 = self.cached_secondary_homonym ? self.cached_secondary_homonym_alternative_spelling : nil
                  possible_secondary_homonyms_alternative_spelling = name4 ? Protonym.with_secondary_homonym_alternative_spelling(name4).without_homonym_or_suppressed.without_taxon_name_classification_array(TAXON_NAME_CLASS_NAMES_UNAVAILABLE_AND_INVALID).not_self(self).with_base_of_rank_class(rank_base).with_project(self.project_id) : []
                  list4 = reduce_list_of_synonyms(possible_secondary_homonyms_alternative_spelling)
                  if !list4.empty?
                    list4.each do |s|
                      soft_validations.add(:base, "Taxon could be a secondary homonym of #{s.cached_name_and_author_year} (alternative spelling)")
                    end
                  end
                end
              end
            end
          end
        end
      end
    end

    def sv_original_combination_relationships

      relationships = self.original_combination_relationships

      unless relationships.empty?
        relationships = relationships.sort_by{|r| r.type_class.order_index }
        ids = relationships.collect{|r| r.subject_taxon_name_id}

        if !ids.include?(self.id)
          soft_validations.add(:base, 'Original relationship to self is not specified')
        elsif ids.last != self.id
          soft_validations.add(:base, 'Original relationship to self should be selected at lowest nomeclatural rank of the original relationships')
        end
      end
    end

    def sv_extant_children
      unless self.parent_id.blank?
        if self.is_fossil?
          taxa = Protonym.where(parent_id: self.id)
          unless taxa.empty?
            taxa.find_each do |t|
              soft_validations.add(:base, 'Extinct taxon has extant children') unless t.is_fossil?
            end
          end
        end
      end
    end

    #  def sv_fix_add_relationship(method, object_id)
    #    begin
    #      Protonym.transaction do
    #        self.save
    #        return true
    #      end
    #    rescue
    #      return false
    #    end
    #  false
    #  end



  end
end


