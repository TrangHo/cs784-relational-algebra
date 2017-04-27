$(document).ready(->
  CodeMirror.defineMode 'ra', ->
    keywords = [
      'pi'
      'sigma'
      'join'
      'and'
      'or'
      'not'
    ]
    keywordsMath = [
      '\u03C3'
      '\u03C0'
      '\u22C8'
    ]
    operators = [
      '>='
      '<='
      '='
      '\u2227'
      '\u2228'
      '!='
      '\u00AC'
      '>'
      '<'
    ]

    matchAny = (stream, array, consume, successorPattern) ->
      i = 0
      while i < array.length
        needle = undefined
        if !successorPattern
          needle = array[i]
        else
          needle = new RegExp('^' + array[i] + successorPattern)
        if stream.match(needle, consume)
          return true
        i++
      false

    seperators = '([\\(\\)[\\]{\\}, \\.\\t]|$)'
    {
      startState: ->
        { inBlockComment: false }
      token: (stream, state) ->
        if state.inBlockComment
          if stream.match(/.*?\*\//, true)
            state.inBlockComment = false
          else
            stream.match /.*/, true
          'comment'
        else if !state.inBlockComment and stream.match(/^\/\*.*/, true)
          state.inBlockComment = true
          'comment'
        else if state.inInlineRelation
          if stream.match(/.*?}/, true)
            state.inInlineRelation = false
          else
            stream.match /.*/, true
          'inlineRelation'
        else if stream.match(/^{/, true)
          state.inInlineRelation = true
          'inlineRelation'
        else if stream.match(/^--[\t ]/, true)
          stream.skipToEnd()
          'comment'
        else if stream.match(/^\/\*.*?$/, true)
          'comment'
        else if matchAny(stream, keywordsMath, true)
          'keyword math'
          # needed for the correct font
        else if matchAny(stream, keywords, true, seperators)
          'keyword'
        else if matchAny(stream, operators, true)
          'operator math'
        else if stream.match(/^\[[0-9]+]/, true)
          'attribute'
        else if stream.match(/^[0-9]+(\.[0-9]+)?/, true)
          'number'
        else if stream.match(/\^'[^']*'/i, true)
          'string'
        else if stream.match(/\^[a-z]+\.[a-z]*/i, true)
          'qualified-column'
        else if stream.match(/^[\(\)\[]\{},]/i, true)
          'bracket'
        else if stream.match(/^[a-z][a-z0-9\.]*/i, true)
          'word'
        else
          stream.next()
          'else'

    }

  ((mod) ->
    if typeof exports == 'object' and typeof module == 'object'
      mod require('../../lib/codemirror')
    else if typeof define == 'function' and define.amd
      define [ '../../lib/codemirror' ], mod
    else
      mod CodeMirror
    return
  ) (CodeMirror) ->
    'use strict'
    CodeMirror.registerHelper 'lint', 'ra', (text) ->
      found = []
      ra.parseError = (str, hash) ->
        loc = hash.loc

        return

      try
        ra.parse text
      catch e
      # Whenever generate a parser from Jison, change parseError to: 
      # throw new Error(hash.loc.first_line + '#' + hash.loc.first_column + '#' + str, hash);
        split = e.message.split('#')
        linenum = parseInt(split[0])
        charnum = parseInt(split[1])
        msg = split[2]
        found.push
          from: CodeMirror.Pos(linenum - 1, charnum)
          to: CodeMirror.Pos(linenum - 1, charnum)
          message: msg
      found
    return
    
  editor = undefined
  editor = CodeMirror.fromTextArea(document.getElementById("code_body"), {
    lineNumbers: true,
    lineWrapping: true,
    matchBrackets: true,
    autoCloseBrackets: true,
    styleActiveLine: true,
    mode: 'ra',
    gutters: ['CodeMirror-lint-markers'],
    lint: true,
    onBlur: ->
      editor.save()
      return
    })

  getCursor = ->
    pos =
      line: editor.getCursor().line
      ch: editor.getCursor().ch

  $('#selection').click ->
    editor.replaceRange('\u03C3', getCursor())

  $('#projection').click ->
    editor.replaceRange('\u03C0', getCursor())

  $('#join').click ->
    editor.replaceRange('\u22C8', getCursor())

  $('#and').click ->
    editor.replaceRange('\u2227', getCursor())

  $('#or').click ->
    editor.replaceRange('\u2228', getCursor())

  $('#not').click ->
    editor.replaceRange('\u00AC', getCursor())

  # Enabling HTML in tooltip
  $ ->
    $('[data-toggle=tooltip]').tooltip html: true, trigger: "hover"
)