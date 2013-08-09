angular.module('TypeaheadName', []).directive('typeaheadName', function() {

  return {
    restrict: 'A',
    scope: true,
    link: function($scope, $element, $attrs) {

      var results_cache;

      var options = $scope.$eval($attrs.typeaheadName);
      var $gender = $element.parents('.control-group').parent().find('.controls .gender');

      function updateResultsCache(elastic_search_json) {
        results_cache = [];
        $(elastic_search_json.hits.hits).each(function(index, hit) {
          var hit_source = hit._source;
          name = hit_source.name;
          weight = hit_source.weight;

          results_cache.push({
            name: name,
            weight: weight
          });
        });
      }

      function prepareQueryForSearch(query) {
        query = removeSpecialCharacters(query);
        query = appendStarToEveryWord(query);
        return query;
      }

      function removeSpecialCharacters(str) {
        var REGEXP = /[^a-zA-Z0-9А-Яа-я]+/g;
        return str.replace(REGEXP, ' ');
      }

      function appendStarToEveryWord(str) {
        return str.split(' ').join('* ') + '*';
      }

      function setGender(json){
        var gender_index = $gender.val() == 'true' ? 1 : 0;
        json.filter.range.gender = {
          from: gender_index, to: gender_index
        };
        return json;
      }

      function getResult(name) {
        var found_result = null;
        $(results_cache).each(function(index, result) {
          if (result.name == name) {
            found_result = result;
          }
        });
        return found_result;
      }

      function getSourceForTypeahead() {
        return $(results_cache).map(function(index, result) {
          return result.name;
        });
      }

      function getQueryJSON(query) {
        var json = options.search_params;
        json.query.queryString.query = query;
        if($gender.length > 0){
          json = setGender(json);
        }
        return JSON.stringify(json);
      }

      $element.typeahead({
        source: function(query, process) {
          var prepared_query = prepareQueryForSearch(query);
          var query_json = getQueryJSON(prepared_query);
          $.post(
            options.source,
            query_json,
            function(elastic_search_json) {
              updateResultsCache(elastic_search_json);
              var source = getSourceForTypeahead();
              process(source);
            },
            'json'
          )
        },
        matcher: function(item) {
          return true;
        },
        highlighter: function(name) {
          var result = getResult(name);
          return '<strong>' + result.name + '</strong>';
        },
        updater: function(name) {
          return name;
        },
        sorter: function(items){
          return items;
        },
        select: $element.data('select')
      });

    }
  };
});
