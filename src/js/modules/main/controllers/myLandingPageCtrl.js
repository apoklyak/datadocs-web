define(['./module', 'angular', 'common', 'lodash'], function (controllers, angular, common, _) {
    'use strict';
    controllers.controller('myLandingPageCtrl', ['$scope', '$rootScope', '$state', 'UserStateService', 'SectionNamesService',
        function ($scope, $rootScope, $state, UserStateService, SectionNamesService) {
            $scope.userState = UserStateService.get();
        }]);
});
