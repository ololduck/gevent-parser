require 'spec_helper'

g = GeventParser::Parser.new
msg = '{"author":{"name":"builder builder","email":"builder@example.com","username":"builder"},"approvals":[{"type":"Verified","description":"Verified","value":"2"}],"comment":"Patch Set 10: Verified+2\n\nBuild Successful \n\nhttp://jenkins/job/job-name/78/ : SUCCESS","patchSet":{"number":"10","revision":"127d0494e011ee5e63a164e66b49a992b2a01d98","parents":["54f479ae8f0d0e216ae66189c3a5ee30bd02ce36"],"ref":"refs/changes/26/48726/10","uploader":{"name":"One Person","email":"one.person@example.com","username":"operson"},"createdOn":1457460976,"author":{"name":"One Person","email":"one.person@example.com","username":"operson"},"isDraft":false,"kind":"REWORK","sizeInsertions":1325,"sizeDeletions":-1938},"change":{"project":"project-name","branch":"master","id":"I753fd1a00a85dcdafdbf986c6e3fbd7d0223f450","number":"48726","subject":"IMP - Major Refactoring","owner":{"name":"One Person","email":"one.person@example.com","username":"operson"},"url":"http://gerrit.example.com:8080/48726","commitMessage":"IMP - Major Refactoring\n\nThe goal of this commit is to add a model object in the MasterControlProgram, for him to fight for the users.\nIt will:\n- able to get tag value form a Collection not to parse a string :)\n- avoid to loop on a Vector to know if a tag is present :)\n- separate the GUI from the Message management.\n\nChange-Id: I753fd1a00a85dcdafdbf986c6e3fbd7d0223f450\n","status":"NEW"},"type":"comment-added","eventCreatedOn":1457460990}'

msgs = [
    msg,
    '{"author":{"name":"Review Bot","username":"bot"},"approvals":[{"type":"Verified","description":"Verified","value":"1"}],"comment":"Patch Set 1: Verified+1","patchSet":{"number":"1","revision":"4a3d33428c4bc732fde1880bc0ffdb3509d0cdcb","parents":["397e504ce025f7142798d72a1e8b0c7fd2078ad4"],"ref":"refs/changes/81/48881/1","uploader":{"name":"One Person","email":"one.person@example.com","username":"operson"},"createdOn":1457453855,"author":{"name":"One Person","email":"one.person@example.com","username":"operson"},"isDraft":false,"kind":"REWORK","sizeInsertions":139,"sizeDeletions":-10},"change":{"project":"roslyn-analysers","branch":"master","id":"I44d540cbe52f7ea9b6887bcf27b092d1b689fe25","number":"48881","subject":"Forbid usage of regions","owner":{"name":"One Person","email":"one.person@example.com","username":"operson"},"url":"http://gerrit.example.com:8080/48881","commitMessage":"Forbid usage of regions\n\nChange-Id: I44d540cbe52f7ea9b6887bcf27b092d1b689fe25\n","status":"NEW"},"type":"comment-added","eventCreatedOn":1457453857}',
    '{"uploader":{"name":"Up Loader","email":"up.loader@example.com","username":"uloader"},"patchSet":{"number":"4","revision":"a430f108845ad3f2ad49ce222246aeb7fcc0135c","parents":["b5dd69062646f143fc3142542f685b81a049237b"],"ref":"refs/changes/22/48922/4","uploader":{"name":"Up Loader","email":"up.loader@example.com","username":"uloader"},"createdOn":1457526839,"author":{"name":"Up Loader","email":"up.loader@example.com","username":"uloader"},"isDraft":false,"kind":"REWORK","sizeInsertions":37,"sizeDeletions":-44},"change":{"project":"clu","branch":"master","id":"I0ed873c9dff6f056ba9613f542fa55e16d1ed0bd","number":"48922","subject":"Add morality values","owner":{"name":"Up Loader","email":"up.loader@example.com","username":"uloader"},"url":"http://gerrit.example.com:8080/48922","commitMessage":"Add morality values\n\nChange-Id: I0ed873c9dff6f056ba9613f542fa55e16d1ed0bd\n","status":"NEW"},"type":"patchset-created","eventCreatedOn":1457526844}'
]

describe GeventParser do
  it 'has a version number' do
    expect(GeventParser::VERSION).not_to be nil
  end

  it 'accepts any known messages without failing' do
    msgs.each { |msg|
      expect(g.parse msg).not_to eq ''
    }
  end

  it 'returns correctly the approval of a changeset' do
    h = JSON.parse(msg)
    expect(g.get_approval h).to eq 2
  end

  it 'can extract the author' do
    h = JSON.parse(msg)
    expect(g.format_author(h['author'])).not_to be nil
  end
end
