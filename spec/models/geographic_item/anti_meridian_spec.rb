require 'rails_helper'
require_relative '../../support/geo/build_rspec_geo'

# include the subclasses, perhaps move this out
Dir[Rails.root.to_s + '/app/models/geographic_item/**/*.rb'].each { |file| require_dependency file }


# An exercise in exploring and handling data that crosses the anti-meridian.
#
#           anti-meridian 
#                |
#           X----|---->
#  east/left     |        west/right
#           <----|-----X
#                |
#
# The take home message- if you use ST_Contains(ST_ShiftLongitude(), ST_ShiftLongitude()) then everything will "just work".
#
#
#
describe GeographicItem, type: :model, group: :geo do

  # after(:all) { clean_slate_geo }

  context 'anti-meridian' do
    # Containers left side/object/A component of ST_Contains(A, B)
    # crosses anti from eastern to western (easterly)
    let(:left_right_anti_box) { 'POLYGON((179.0 27.0, -178.0 27.0, -178.0 25.0, 179.0 25.0, 179.0 27.0))' }
    # crosses anti from western to eastern (westerly)
    let(:right_left_anti_box) { 'POLYGON((-179.0 27.0, 178.0 27.0,  178.0 25.0, -179.0 25.0, -179.0 27.0))' }

    # Test/target/found objects, right side/object B component of ST_Contains(A, B)
    #- antimeridian crossing line contained by anti_box, crosses anti from eastern to western (easterly)
    let(:left_right_anti_line) { 'LINESTRING (179.5 26.0, -179.5 25.5)' }
    #- antimeridian crossing line contained by anti_box, crosses anti from western to eastern (westerly)
    let(:right_left_anti_line) { 'LINESTRING (-179.5 26.0, 179.5 25.5)' }

    # test/target/found objects right side/object B component of ST_Contains(A, B)
    #  points( outside, inside )
    #- antimeridian crossing line contained by anti_box, crosses anti from eastern to western (easterly)
    let(:left_right_anti_line_partial) { 'LINESTRING (170.5 26.0, -179.8 25.5)' } #- partially contained by anti_box
    #- antimeridian crossing line contained by anti_box, crosses anti from western to eastern (westerly)
    let(:right_left_anti_line_partial) { 'LINESTRING (-170.5 26.0, 179.8 25.5)' } #- partially contained by anti_box

    # test/target/found objects right side/object B component of ST_Contains(A, B)
    #  points( outside, outside )
    #- antimeridian crossing line NOT contained by anti_box, crosses anti from eastern to western (easterly)
    let(:left_right_anti_line_out) { 'LINESTRING (170.5 26.0, 175.0 25.5)' }
    #- antimeridian crossing line NOT contained by anti_box, crosses anti from western to eastern (westerly)
    let(:right_left_anti_line_out) { 'LINESTRING (-170.5 26.0, -175.8 25.5)' }

    #- antimeridian string
    let(:anti_s) { 'LINESTRING (180 89.0, 180 -89)' } 

    context 'raw SQL' do

      context 'box checks' do 
        [:left_right_anti_box, :right_left_anti_box].each do |b|
          specify "box #{b} is ST_IsValid?" do 
            expect(GeographicItem.find_by_sql(
              "SELECT ST_IsValid(ST_GeomFromText('#{send(b)}')) as r;"
            ).first.r).to be true 
          end

          specify "#{b} ST_Intersects with anti-merdian (we can detect things crossing the AM" do 
            expect(GeographicItem.find_by_sql(
              "SELECT ST_Intersects(ST_GeogFromText('#{send(b)}'), ST_GeogFromText('#{anti_s}')) as r;"
            ).first.r).to be true 
          end
        end
      end

      context 'ST_ShiftLongitude NOT applied to parameters/containers of ST_Contains(A, B)' do
        context 'possible results are' do

          context 'entirely enclosed in right-left anti-box' do
            specify 'left-right anti line' do
              expect(GeographicItem.find_by_sql(
                "SELECT ST_Contains(ST_GeomFromText('#{right_left_anti_box}'), ST_GeomFromText('#{left_right_anti_line}')) as r;"
              ).first.r).to be false
            end

            specify 'right-left anti line' do
              expect(GeographicItem.find_by_sql(
                "SELECT ST_Contains(ST_GeomFromText('#{right_left_anti_box}'), ST_GeomFromText('#{right_left_anti_line}')) as r;"
              ).first.r).to be false
            end
          end

          context 'entirely enclosed in left-right anti-box' do
            specify 'left-right anti line' do
              expect(GeographicItem.find_by_sql(
                "SELECT ST_Contains(ST_GeomFromText('#{left_right_anti_box}'), ST_GeomFromText('#{left_right_anti_line}')) as r;"
              ).first.r).to be false
            end

            specify 'west-east line' do
              expect(GeographicItem.find_by_sql(
                "SELECT ST_Contains(ST_GeomFromText('#{left_right_anti_box}'), ST_GeomFromText('#{right_left_anti_line}')) as r;"
              ).first.r).to be false
            end
          end

          context 'demonstrate that anti_boxes are big for geometries/ST_Contains' do
            @boxes = %I{left_right_anti_box right_left_anti_box}

            @boxes.each do |b|
              [ '-90 26', '0 26', '90 26' ].each do |p| # points in really wide box
                specify "#{b}/#{p}" do
                  expect(GeographicItem.find_by_sql(
                    "SELECT ST_Contains(ST_GeomFromText('#{send(b)}'), ST_GeomFromText('POINT(#{p})')) as r;"
                  ).first.r).to be true 
                end
              end

              ['180 26', '179.9 26', '-179.9 26' ].each do |p| # points not in really wide box 
                specify "#{b}/#{p}" do
                  expect(GeographicItem.find_by_sql(
                    "SELECT ST_Contains(ST_GeomFromText('#{send(b)}'), ST_GeomFromText('POINT(#{p})')) as r;"
                  ).first.r).to be false 
                end
              end
            end

            context 'not (completely) contained/enclosed' do
              @boxes = %I{left_right_anti_box right_left_anti_box}

              @boxes.each do |b|
                %I{left_right_anti_line_out right_left_anti_line_out}.each do |s|
                  specify "#{b}/#{s}" do
                    expect(GeographicItem.find_by_sql(
                      "SELECT ST_Contains(ST_GeomFromText('#{send(b)}'), ST_GeomFromText('#{send(s)}')) as r;"
                    ).first.r).to be true 
                  end
                end

                %I{left_right_anti_line_partial right_left_anti_line_partial}.each do |s|
                  specify "#{b}/#{s}" do
                    expect(GeographicItem.find_by_sql(
                      "SELECT ST_Contains(ST_GeomFromText('#{send(b)}'), ST_GeomFromText('#{send(s)}')) as r;"
                    ).first.r).to be false 
                  end
                end
              end
            end
          end
        end
      end

      context 'ST_ShiftLongitude applied to parameters/containers of ST_Contains(A, B)' do

        context 'demonstrate that shifted anti_boxes are not big' do
          @boxes = %I{left_right_anti_box right_left_anti_box}

          @boxes.each do |b|
            [ '-90 26', '0 26', '90 26' ].each do |p| # points in really wide box
              specify "shifted #{b}/#{p}" do
                expect(GeographicItem.find_by_sql(
                  "SELECT ST_Contains(ST_ShiftLongitude(ST_GeomFromText('#{send(b)}')), ST_GeomFromText('POINT(#{p})')) as r;"
                ).first.r).to be false 
              end
            end

            ['180 26', '179.9 26' ].each do |p| # points not in really wide box 
              specify "shifted #{b}/#{p}" do
                expect(GeographicItem.find_by_sql(
                  "SELECT ST_Contains(ST_ShiftLongitude(ST_GeomFromText('#{send(b)}')), ST_GeomFromText('POINT(#{p})')) as r;"
                ).first.r).to be true 
              end
            end

            specify "#{b} (positive shifted does not contain negative point)" do
              expect(GeographicItem.find_by_sql(
                "SELECT ST_Contains(ST_ShiftLongitude(ST_GeomFromText('#{send(b)}')), ST_GeomFromText('POINT(-179.9 26)')) as r;"
              ).first.r).to be false 
            end

            specify "#{b} (both shifted does contain point)" do
              expect(GeographicItem.find_by_sql(
                "SELECT ST_Contains(ST_ShiftLongitude(ST_GeomFromText('#{send(b)}')), ST_ShiftLongitude(ST_GeomFromText('POINT(-179.9 26)'))) as r;"
              ).first.r).to be true 
            end
          end
        end


        context 'possible results are' do
          context 'entirely enclosed in right-left anti-box' do
            specify 'left-right anti line' do
              expect(GeographicItem.find_by_sql(
                "SELECT ST_Contains(ST_ShiftLongitude(ST_GeomFromText('#{right_left_anti_box}')), ST_ShiftLongitude(ST_GeomFromText('#{left_right_anti_line}'))) as r;"
              ).first.r).to be true
            end

            specify 'west-east line' do
              expect(GeographicItem.find_by_sql(
                "SELECT ST_Contains(ST_ShiftLongitude(ST_GeomFromText('#{right_left_anti_box}')), ST_ShiftLongitude(ST_GeomFromText('#{right_left_anti_line}'))) as r;"
              ).first.r).to be true
            end
          end

          context 'entirely enclosed in left-right anti-box' do
            specify 'left-right anti line' do
              expect(GeographicItem.find_by_sql(
                "SELECT ST_Contains(ST_ShiftLongitude(ST_GeomFromText('#{left_right_anti_box}')), ST_ShiftLongitude(ST_GeomFromText('#{left_right_anti_line}'))) as r;"
              ).first.r).to be true
            end

            specify 'right-left anti line' do
              expect(GeographicItem.find_by_sql(
                "SELECT ST_Contains(ST_ShiftLongitude(ST_GeomFromText('#{left_right_anti_box}')), ST_ShiftLongitude(ST_GeomFromText('#{right_left_anti_line}'))) as r;"
              ).first.r).to be true
            end
          end

          context 'not (completely) contained/enclosed' do
            @out = %I{left_right_anti_line_partial right_left_anti_line_partial left_right_anti_line_out right_left_anti_line_out}

            @out.each do |s|
              specify "#{s}" do
                expect(GeographicItem.find_by_sql(
                  "SELECT ST_Contains(ST_ShiftLongitude(ST_GeomFromText('#{right_left_anti_box}')), ST_ShiftLongitude(ST_GeomFromText('#{send(s)}'))) as r;"
                ).first.r).to be false
              end
            end
          end
        end
      end
    end

    context 'Demonstrate that anti_boxes are small for geographies/ST_Covers' do
      # Note _lines can not be used in ST_Covers!

      %I{left_right_anti_box right_left_anti_box}.each do |b|
        [ '-90 26', '0 26', '90 26' ].each do |p| # points in really wide box
          specify "#{b}/#{p}" do
            expect(GeographicItem.find_by_sql(
              "SELECT ST_Covers(ST_GeogFromText('#{send(b)}'), ST_GeogFromText('POINT(#{p})')) as r;"
            ).first.r).to be false 
          end
        end

        ['180 26', '179.9 26', '-179.9 26' ].each do |p| # points not in really wide box 
          specify "#{b}/#{p}" do
            expect(GeographicItem.find_by_sql(
              "SELECT ST_Covers(ST_GeogFromText('#{send(b)}'), ST_GeogFromText('POINT(#{p})')) as r;"
            ).first.r).to be true 
          end
        end
      end
    end
  end
end