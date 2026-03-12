# frozen_string_literal: true

require 'spec_helper'

module MemMan
  describe Block do
    subject { described_class.new(block_size) }

    let(:block_size) { 5 }

    context 'instance interface' do
      it 'exposes a write method' do
        expect(subject).to respond_to(:write)
      end

      it 'exposes a read method' do
        expect(subject).to respond_to(:read)
      end
    end

    it 'initializes a byte array of the given size' do
      expect(subject.bytes.length).to eq(block_size)
    end

    context 'writting to virtual memory' do
      it 'writes to the array as virtual memory' do
        subject.write('a')
        expect(subject.bytes[0].value).to eq('a')
      end

      it 'can write multiple bytes at a time' do
        subject.write('1234')
        expect(subject.bytes.map { |b| b ? b.value : nil }).to eq(['1','2','3','4',nil])
      end

      it 'throws an error when a write is too big' do
        expect{ subject.write('123456') }.to raise_error MemoryOverrunError
      end
    end

    context 'reading from virtual memory' do
      it 'returns an array empty array of bytes before a write' do
        expect(subject.read).to eq([nil,nil,nil,nil,nil])
      end

      it 'reads the written bytes' do
        subject.write('123')
        expect(subject.read).to eq(['1','2','3',nil,nil])
      end

      context 'block is freed' do
        before { subject.free }

        it 'errors when trying to read' do
          expect{ subject.read }.to raise_error IllegalAccessError
        end

        it 'errors on write attempts' do
          expect{ subject.read }.to raise_error IllegalAccessError
        end
      end
    end

    context 'allocating a sub block' do
      let(:parent) { described_class.new(block_size) }
      let(:sub_size) { 2 }

      it 'creates a new block' do
        expect(parent.alloc(2)).to be_a(Block)
      end
    end
  end
end
