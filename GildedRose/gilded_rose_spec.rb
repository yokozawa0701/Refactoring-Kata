# frozen_string_literal: true

require File.join(File.dirname(__FILE__), 'gilded_rose')

describe GildedRose do
  describe '#update_quality' do
    let(:sell_in) { 30 }
    let(:quality) { 20 }

    context 'Item#nameがそれ以外（foo）の場合' do
      let(:name) { 'foo' }

      it 'Item#qualityが1小さくなること' do
        items = [Item.new(name, sell_in, quality)]
        GildedRose.new(items).update_quality
        expect(items[0].quality).to eq 19
      end

      it 'Item#sell_inが1小さくなること' do
        items = [Item.new(name, sell_in, quality)]
        GildedRose.new(items).update_quality
        expect(items[0].sell_in).to eq 29
      end

      context 'Item#qualityが0の時' do
        let(:quality) { 0 }
        it 'Item#qualityがマイナスにならないこと' do
          items = [Item.new(name, sell_in, quality)]
          GildedRose.new(items).update_quality
          expect(items[0].quality).to eq 0
        end
      end

      context 'Item#qualityが50の時' do
        let(:quality) { 50 }
        it 'Item#qualityが1小さくなること' do
          items = [Item.new(name, sell_in, quality)]
          GildedRose.new(items).update_quality
          expect(items[0].quality).to eq 49
        end

        it 'Item#sell_inが1小さくなること' do
          items = [Item.new(name, sell_in, quality)]
          GildedRose.new(items).update_quality
          expect(items[0].sell_in).to eq 29
        end
      end

      it 'Item#sell_inが0の時、Item#qualityが2小さくなること' do
        items = [Item.new(name, 0, quality)]
        GildedRose.new(items).update_quality
        expect(items[0].quality).to eq 18
      end
    end

    context 'Item#nameがAged Brieの場合' do
      let(:name) { 'Aged Brie' }

      it 'Item#qualityが1大きくなること' do
        items = [Item.new(name, sell_in, quality)]
        GildedRose.new(items).update_quality
        expect(items[0].quality).to eq 21
      end

      it 'Item#qualityが50より大きくならないこと' do
        items = [Item.new(name, sell_in, 50)]
        GildedRose.new(items).update_quality
        expect(items[0].quality).to eq 50
      end
    end

    context 'Item#nameが Sulfuras, Hand of Ragnaros の場合' do
      let(:name) { 'Sulfuras, Hand of Ragnaros' }

      it 'Item#sell_inが変わらないことこと' do
        items = [Item.new(name, sell_in, quality)]
        GildedRose.new(items).update_quality
        expect(items[0].sell_in).to eq 30
      end

      it 'Item#qualityが変わらないこと' do
        items = [Item.new(name, sell_in, quality)]
        GildedRose.new(items).update_quality
        expect(items[0].quality).to eq quality
      end
    end
  end
end
