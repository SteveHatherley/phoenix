/**
 * Part of phoenix project.
 *
 * @copyright  Copyright (C) 2017 {ORGANIZATION}. All rights reserved.
 * @license    GNU General Public License version 2 or later.
 */

;(function($) {
    "use strict";

    var plugin = 'listDependent';

    var nope = function (value, ele, dep) {};

    var defaultOptions = {
        ajax_url: '',
        default_value: null,
        initial_load: true,
        request: {
            value_field: 'value'
        },
        response: {
            text_field: 'title',
            value_field: 'id'
        },
        hooks: {
            before_request: nope,
            after_request: nope
        }
    };

    /**
     * Class init.
     * @param {jQuery}        $element
     * @param {jQuery|string} dependent
     * @param {Object}        options
     * @constructor
     */
    var ListDependent = function($element, dependent, options) {
        this.element = $element;
        this.options = $.extend(true, {}, defaultOptions, options);
        this.dependent = $(dependent);

        this.bindEvents();

        if (this.options.initial_load) {
            this.changeList(this.dependent.val());
        }
    };

    ListDependent.prototype = {

        /**
         * Bind events.
         */
        bindEvents: function() {
            var self = this;

            this.dependent.on('change', function (event) {
                var $this = $(this);
                self.changeList($this.val());
            });
        },

        /**
         * Update the list elements.
         *
         * @param {*} value
         */
        changeList: function(value) {
            value = value || this.dependent.val();
            var self   = this;
            var before = this.options.hooks.before_request;
            var after  = this.options.hooks.after_request;
            var uri    = new SimpleURI(this.options.ajax_url);
            uri.setVar(this.options.request.value_field, value);

            before.call(self, value, self.element, self.dependent);

            $.get(uri.toString())
                .done(function (response) {
                    if (response.success) {
                        self.element.empty();

                        $.each(response.data, function() {
                            var value = this[self.options.response.value_field];
                            var option = $('<option>' + this[self.options.response.text_field] + '</option>');
                            option.attr('value', value);

                            if (this.attributes) {
                                $.each(this.attributes, function (index) {
                                    option.attr(index, this);
                                });
                            }

                            if (self.options.default_value == value) {
                                option.attr('selected', 'selected');
                            }

                            self.element.append(option);
                        });

                        self.element.trigger('chosen:updated');
                        self.element.trigger('change');
                    } else {
                        console.error(response.message);
                    }
                }).fail(function(response) {
                    console.error(response.message);
                }).always(function () {
                    after.call(self, value, self.element, self.dependent);
                });
        }
    };

    /**
     * Push plugins.
     *
     * @param {jQuery} dependent
     * @param {Object} options
     *
     * @returns {*}
     */
    $.fn[plugin] = function(dependent, options) {
        if (!$.data(this, "phoenix." + plugin)) {
            $.data(this, "phoenix." + plugin, new ListDependent(this, dependent, options));
        }

        return $.data(this, "phoenix." + plugin);
    };
})(jQuery);