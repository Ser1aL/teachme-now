module InterestsHelper

  def interests_paper_configuration
    {
      0 => { paper_type: 't1', connection_type: 't1', delimiter: false },
      1 => { paper_type: 't4', connection_type: 't2', delimiter: false },
      2 => { paper_type: 't3', connection_type: false, delimiter: true },
      3 => { paper_type: 't4', connection_type: 't1', delimiter: false },
      4 => { paper_type: 't5', connection_type: false, delimiter: true }
    }
  end
end
