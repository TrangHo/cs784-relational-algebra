var raSyntaxCheck, editor;

$(document).ready(function() {
  var getCursor;
  CodeMirror.defineMode('ra', function() {
    var keywords, keywordsMath, matchAny, operators, seperators;
    keywords = ['pi', 'sigma', 'join', 'and', 'or', 'not'];
    keywordsMath = ['\u03C3', '\u03C0', '\u22C8'];
    operators = ['>=', '<=', '=', '\u2227', '\u2228', '!=', '\u00AC', '>', '<'];
    matchAny = function(stream, array, consume, successorPattern) {
      var i, needle;
      i = 0;
      while (i < array.length) {
        needle = void 0;
        if (!successorPattern) {
          needle = array[i];
        } else {
          needle = new RegExp('^' + array[i] + successorPattern);
        }
        if (stream.match(needle, consume)) {
          return true;
        }
        i++;
      }
      return false;
    };
    seperators = '([\\(\\)[\\]{\\}, \\.\\t]|$)';
    return {
      startState: function() {
        return {
          inBlockComment: false
        };
      },
      token: function(stream, state) {
        if (state.inBlockComment) {
          if (stream.match(/.*?\*\//, true)) {
            state.inBlockComment = false;
          } else {
            stream.match(/.*/, true);
          }
          return 'comment';
        } else if (!state.inBlockComment && stream.match(/^\/\*.*/, true)) {
          state.inBlockComment = true;
          return 'comment';
        } else if (state.inInlineRelation) {
          if (stream.match(/.*?}/, true)) {
            state.inInlineRelation = false;
          } else {
            stream.match(/.*/, true);
          }
          return 'inlineRelation';
        } else if (stream.match(/^{/, true)) {
          state.inInlineRelation = true;
          return 'inlineRelation';
        } else if (stream.match(/^--[\t ]/, true)) {
          stream.skipToEnd();
          return 'comment';
        } else if (stream.match(/^\/\*.*?$/, true)) {
          return 'comment';
        } else if (matchAny(stream, keywordsMath, true)) {
          return 'keyword math';
        } else if (matchAny(stream, keywords, true, seperators)) {
          return 'keyword';
        } else if (matchAny(stream, operators, true)) {
          return 'operator math';
        } else if (stream.match(/^\[[0-9]+]/, true)) {
          return 'attribute';
        } else if (stream.match(/^[0-9]+(\.[0-9]+)?/, true)) {
          return 'number';
        } else if (stream.match(/\^'[^']*'/i, true)) {
          return 'string';
        } else if (stream.match(/\^[a-z]+\.[a-z]*/i, true)) {
          return 'qualified-column';
        } else if (stream.match(/^[\(\)\[]\{},]/i, true)) {
          return 'bracket';
        } else if (stream.match(/^[a-z][a-z0-9\.]*/i, true)) {
          return 'word';
        } else {
          stream.next();
          return 'else';
        }
      }
    };
  });
  (function(mod) {
    if (typeof exports === 'object' && typeof module === 'object') {
      mod(require('../../lib/codemirror'));
    } else if (typeof define === 'function' && define.amd) {
      define(['../../lib/codemirror'], mod);
    } else {
      mod(CodeMirror);
    }
  })(function(CodeMirror) {
    'use strict';
    CodeMirror.registerHelper('lint', 'ra', function(text) {
      var found = [];
      try {
        ra.parse(text);
      } catch (e) {
        // Error message format:
        // start_linenum # start_charnum # end_linenum # end_charnum # msg
        var split = e.message.split('#');
        var start_linenum = parseInt(split[0]);
        var start_charnum = parseInt(split[1]);
        var end_linenum = parseInt(split[2]);
        var end_charnum = parseInt(split[3]);
        var msg = split[4];
        found.push({
          from: CodeMirror.Pos(start_linenum - 1, start_charnum),
          to: CodeMirror.Pos(end_linenum - 1, end_charnum),
          message: msg
        });
      }
      return found;
    });
  });

  editor = CodeMirror.fromTextArea(document.getElementById("code_body"), {
    lineNumbers: true,
    lineWrapping: true,
    matchBrackets: true,
    autoCloseBrackets: true,
    styleActiveLine: true,
    mode: 'ra',
    gutters: ['CodeMirror-lint-markers'],
    lint: true,
    onBlur: function() {
      editor.save();
    }
  });
  getCursor = function() {
    var pos;
    return pos = {
      line: editor.getCursor().line,
      ch: editor.getCursor().ch
    };
  };
  $('#selection').click(function() {
    return editor.replaceRange('\u03C3', getCursor());
  });
  $('#projection').click(function() {
    return editor.replaceRange('\u03C0', getCursor());
  });
  $('#join').click(function() {
    return editor.replaceRange('\u22C8', getCursor());
  });
  $('#and').click(function() {
    return editor.replaceRange('\u2227', getCursor());
  });
  $('#or').click(function() {
    return editor.replaceRange('\u2228', getCursor());
  });
  $('#not').click(function() {
    return editor.replaceRange('\u00AC', getCursor());
  });
  return $(function() {
    return $('[data-toggle=tooltip]').tooltip({
      html: true,
      trigger: "hover"
    });
  });
});


/*
 * JSON format
 * relation: (TODO: project, join)
 * - {"type": "ID", "name": name_of_the_relation }
 * - {"type": "select", "predicate": predicate, "relation": relation}
 * - {"type": "project", "varlist": array_of_var, "relation": relation}
 * - {"type": "join", "left": relation, "right": relation, (optional) "predicate": predicate}
 *
 * predicate:
 * - {"type": "and/or", "left": left_predicate, "right": right_predicate}
 * - {"type": "not", "right": predicate}
 * - {"type": comparison, "left": term, "right": term}
 *
 * term:
 * - var
 * - NUMBER
 * - STRING with single quote
 *
 * var:
 * - "ID"
 * - "ID.ID"
 */

var raSyntaxCheck = function(textId) {
  var encodedStr = editor.getValue();
  var parser = new DOMParser;
  var dom = parser.parseFromString(
      '<!doctype html><body>' + encodedStr,
      'text/html');
  var text = dom.body.textContent;
  try {
    var jsonText = ra.parse(text);
    document.getElementById("solution_json").value = jsonText;
    return true;
  } catch (_error) {
    alert("Please fix syntax error before submission")
    return false;
  }
};