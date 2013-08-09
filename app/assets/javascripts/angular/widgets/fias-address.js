angular.module('FIASAddress', []).directive('fiasAddress', function() {

  var type_to_level_limit_mapping = {
    'birth_place': 6,
    'residence_place': 7,
    'legal_place': 7,
    'death_place': 6,
    'address_or_place_name': 7
  };

  return {
    restrict: 'A',
    scope: true,
    link: function($scope, $element, $attrs) {

      var results_cache;

      var options = $scope.$eval($attrs.fiasAddress);
      var level_limit = type_to_level_limit_mapping[options.type];

      var $full_address_input = $element.find('input.fias-address-full-address');
      var $raw_address_input = $element.find('input.fias-address-raw-address');
      var $fias_input = $element.find('input.fias-address-fias');
      var $kladr_input = $element.find('input.fias-address-kladr');
      var $okato_input = $element.find('input.fias-address-okato');

      var $classified_marker = $element.find('.fias-address-classified');

      var $house_input = $element.find('input.fias-address-house');
      var $building_input = $element.find('input.fias-address-building');
      var $structure_input = $element.find('input.fias-address-structure');
      var $apartment_input = $element.find('input.fias-address-apartment');

      var $copy_button = $element.find('button.fias-address-copy');

      $copy_button.attr('tabindex', '-1');

      if($fias_input.val().length > 0){
        setClassified();
      }


      function stateUpdateIsNecessary() {
        // Update is only necessary if widget was focused and some search results were fetched and cached,
        // in other words, user manipulated a widget and widget's state should be properly changed on blur.
        // Otherwise we can pass the update process and leave values as they were before focus
        // that is the right behaviour if user is just tabbing through inputs and no search requests are sent.
        return typeof results_cache != 'undefined';
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

      function getQueryJSON(query) {
        var json = {
          query: {
            queryString: {
              query: query,
              fields: ['full_address', 'formal_name^5'],
              default_operator: 'and'
            }
          },
          sort: ['_score', 'place_code', 'city_code'],
          filter: {
            range: {
              level: {from: 0, to: level_limit}
            }
          },
          highlight: {
            pre_tags: ['<strong>'],
            post_tags: ['</strong>'],
            fields: {
              full_address: {
                fragment_size: 150,
                number_of_fragments: 3
              }
            }
          }
        };
        return JSON.stringify(json);
      }

      function setClassified() {
        $classified_marker.removeClass('hide');
      }

      function resetClassified() {
        $classified_marker.addClass('hide');
      }

      function setHidden(result) {
        if(result.fias){
          setClassified();
        }else{
          resetClassified();
        }

        $fias_input.val(result.fias);
        $kladr_input.val(result.kladr);
        $okato_input.val(result.okato);
      }

      function resetHidden() {
        resetClassified();

        $fias_input.val('');
        $kladr_input.val('');
        $okato_input.val('');
      }

      function updateHidden() {
        var full_address = $full_address_input.val();
        var result = getResult(full_address);
        if (result) {
          setHidden(result);
        } else {
          resetHidden();
        }
      }

      function setFull(result) {
        $full_address_input.val(result.full_address);
      }

      function resetFull() {
        $full_address_input.val('');
      }

      function updateFull() {
        var full_address = $full_address_input.val();
        var result = getResult(full_address);
        if (result) {
          setFull(result);
        } else if(options.resetFull) {
          resetFull();
        }
      }

      function setRaw() {
        var full_address = $full_address_input.val();
        if (full_address) {
          var house = $house_input.val();
          var building = $building_input.val();
          var structure = $structure_input.val();
          var apartment = $apartment_input.val();

          var house_str     = house     ? ', д. '    + house     : '';
          var building_str  = building  ? ', корп. ' + building  : '';
          var structure_str = structure ? ', стр. '  + structure : '';
          var apartment_str = apartment ? ', кв. '   + apartment : '';

          $raw_address_input.val(full_address + house_str + building_str + structure_str + apartment_str);
        }
      }

      function updateResultsCache(elastic_search_json) {
        results_cache = [];
        $(elastic_search_json.hits.hits).each(function(index, hit) {
          var hit_source = hit._source;
          var full_address = hit_source.full_address;
          var short_name = hit_source.short_name;
          var formal_name = hit_source.formal_name;
          var fias = hit_source.fias;
          var kladr = hit_source.kladr;
          var okato = hit_source.okato;
          var highlighted_full_address = hit.highlight ? hit.highlight.full_address : full_address;
          results_cache.push({
            full_address: full_address,
            short_name: short_name,
            formal_name: formal_name,
            fias: fias,
            kladr: kladr,
            okato: okato,
            highlighted_full_address: highlighted_full_address
          });
        });
      }

      function getResult(full_address) {
        var found_result = null;
        $(results_cache).each(function(index, result) {
          if (result.full_address == full_address) {
            found_result = result;
          }
        });
        return found_result;
      }

      function getSourceForTypeahead() {
        return $(results_cache).map(function(index, result) {
          return result.full_address;
        });
      }

      function updateRawOnFocusIfEmpty() {
        if (!$raw_address_input.val()) {
          setRaw();
          var raw_address_input = this;
          setTimeout(function() {
            raw_address_input.selectionStart = raw_address_input.selectionEnd = $raw_address_input.val().length;
          }, 100); // some time is needed for browser to calculate selection start and end so that they can be edited
        }
      }

      $full_address_input.typeahead({
        source: function(query, process) {
          var prepared_query = prepareQueryForSearch(query);
          var query_json = getQueryJSON(prepared_query);
          $.post(
            Settings.urls.search.address,
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
        highlighter: function(full_address) {
          var result = getResult(full_address);
          return '<strong>' + result.short_name + '. ' + result.formal_name + '</strong><br/><em><small>' + result.highlighted_full_address + '</small></em>';
        },
        updater: function(full_address) {
          return full_address;
        },
        sorter: function(items){
          return items;
        }
      });

      $full_address_input.on('change', function() {
        updateHidden();
      });

      $full_address_input.on('blur', function() {
        if (stateUpdateIsNecessary()) {
          updateHidden();
          updateFull();
        }
      });

      $raw_address_input.on('focus', function() {
        updateRawOnFocusIfEmpty();
      });

      $copy_button.on('click', function(event) {
        event.preventDefault();
        setRaw();
      });

    }
  };
});
