# frozen_string_literal: true

require File.join(File.dirname(__FILE__), 'gilded_rose')

describe GildedRose do
  describe '#update_quality' do
    let(:items) { [Item.new(name, sell_in, quality)] }
    let(:sell_in) { 30 }
    let(:quality) { 20 }

    before do
      GildedRose.new(items).update_quality
    end

    context 'Item#nameがそれ以外（foo）の場合' do
      let(:name) { 'foo' }

      it 'Item#qualityが1小さくなること' do
        expect(items[0].quality).to eq 19
      end

      it 'Item#sell_inが1小さくなること' do
        expect(items[0].sell_in).to eq 29
      end

      context 'Item#qualityが0の場合' do
        let(:quality) { 0 }
        it 'Item#qualityがマイナスにならないこと' do
          expect(items[0].quality).to eq 0
        end
      end

      context 'Item#qualityが50の場合' do
        let(:quality) { 50 }

        it 'Item#qualityが1小さくなること' do
          expect(items[0].quality).to eq 49
        end

        it 'Item#sell_inが1小さくなること' do
          expect(items[0].sell_in).to eq 29
        end
      end

      context 'Item#sell_inが0の場合' do
        let(:sell_in) { 0 }

        it 'Item#qualityが2小さくなること' do
          expect(items[0].quality).to eq 18
        end
      end
    end

    context 'Item#nameがAged Brieの場合' do
      let(:name) { 'Aged Brie' }

      it 'Item#qualityが1大きくなること' do
        expect(items[0].quality).to eq 21
      end

      context 'Item#qualityが50場合' do
        let(:quality) { 50 }

        it 'Item#qualityが増えないこと' do
          expect(items[0].quality).to eq 50
        end
      end

      context 'Item#qualityが0の場合' do
        let(:quality) { 0 }

        it 'Item#qualityが1大きくなること' do
          expect(items[0].quality).to eq 1
        end
      end

      context 'Item#sell_inが0の場合' do
        let(:sell_in) { 0 }

        it 'Item#qualityが2大きくなること' do
          expect(items[0].quality).to eq 22
        end

        context 'Item#qualityが49場合' do
          let(:quality) { 49 }

          it 'Item#qualityが1大きくなること' do
            expect(items[0].quality).to eq 50
          end
        end
      end
    end

    context 'Item#nameが Sulfuras, Hand of Ragnaros の場合' do
      let(:name) { 'Sulfuras, Hand of Ragnaros' }
      let(:quality) { 80 }

      it 'Item#sell_inが変わらないことこと' do
        expect(items[0].sell_in).to eq 30
      end

      it 'Item#qualityが変わらないこと' do
        expect(items[0].quality).to eq quality
      end
    end

    context 'Item#nameが Backstage passes to a TAFKAL80ETC concert の場合' do
      let(:name) { 'Backstage passes to a TAFKAL80ETC concert' }

      it 'Item#qualityが1大きくなること' do
        expect(items[0].quality).to eq 21
      end

      context 'Item#qualityが0の場合' do
        let(:quality) { 0 }

        it 'Item#qualityが1大きくなること' do
          expect(items[0].quality).to eq 1
        end
      end

      context 'Item#sell_inが' do
        context '10日以内の場合' do
          let(:sell_in) { 10 }

          it 'Item#qualityが2大きくなること' do
            expect(items[0].quality).to eq 22
          end

          context 'Item#qualityが0の場合' do
            let(:quality) { 0 }

            it 'Item#qualityが2大きくなること' do
              expect(items[0].quality).to eq 2
            end
          end
        end
        context '5日以内の場合' do
          let(:sell_in) { 5 }

          it 'Item#qualityが3大きくなること' do
            expect(items[0].quality).to eq 23
          end

          context 'Item#qualityが0の場合' do
            let(:quality) { 0 }

            it 'Item#qualityが3大きくなること' do
              expect(items[0].quality).to eq 3
            end
          end
        end
      end

      context 'Item#sell_inが0の場合' do
        let(:sell_in) { 0 }

        it 'Item#qualityが0になること' do
          expect(items[0].quality).to eq 0
        end
      end
    end
  end
end
