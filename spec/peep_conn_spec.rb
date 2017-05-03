require 'spec_helper'

RSpec.describe PeepConn do
  it 'has a version number' do
    expect(PeepConn::VERSION).not_to be nil
  end

  it 'has access to table name constants' do
    expect(PeepConn::TABLE_NAMES).not_to be nil
  end
end
