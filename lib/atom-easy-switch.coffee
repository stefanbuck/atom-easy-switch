{CompositeDisposable} = require 'atom'
{filter} = require 'fuzzaldrin'
PathLoader = require './path-loader'

module.exports = AtomEasySwitch =
  atomEasySwitchView: null
  modalPanel: null
  subscriptions: null

  activate: (state) ->
    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'atom-easy-switch:toggle': => @toggle()

  deactivate: ->
    @subscriptions.dispose()

  getSearchTerm: ->
    suffix = '.test'
    filePath = atom.workspace.getActiveTextEditor().getPath();
    ext = path.extname(filePath);
    fileName = path.basename(filePath);

    if fileName.indexOf(suffix) > -1
      search = suffix + ext
      replace = ext;
    else
      search = ext
      replace = suffix + ext;

    fileName.replace(search, replace);

  toggle: ->
    @loadPathsTask?.terminate()
    @loadPathsTask = PathLoader.startTask (@paths) =>
      filePath = filter(@paths, @getSearchTerm(), {maxResults:1})[0];
      if filePath
        atom.workspace.open(filePath)

 destroy: ->
    @loadPathsTask?.terminate()
