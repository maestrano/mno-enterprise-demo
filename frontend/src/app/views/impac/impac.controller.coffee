angular.module 'mnoEnterpriseAngular'
  .controller 'ImpacController', ($scope, $state, $timeout, $http, ImpacDashboardsSvc, ImpacUtilities, MnoeCurrentUser, MnoeOrganizations, DOCK_CONFIG, IMPAC_CONFIG) ->
    'ngInject'

    vm = this
    vm.isImpacShown = false
    vm.isDockEnabled = DOCK_CONFIG.enabled

    # Show button after dashboard load
    vm.showInvoicesButton = false
    ImpacDashboardsSvc.load().then (dhb) ->
      $timeout ->
        vm.showInvoicesButton = true
      ,2000

    # Download invoices
    impacBase = "#{IMPAC_CONFIG.protocol}://#{IMPAC_CONFIG.host}/api"
    ssoSessionId = MnoeCurrentUser.user.sso_session
    orgUid = undefined
    fyEndMonth = undefined
    from = undefined
    to = undefined
    paramsString = ->
      "".concat('sso_session=', ssoSessionId, '&')
      .concat('attributes[transaction_date]=~m/~d/~Y', '&')
      .concat('attributes[transaction_number]=0', '&')
      .concat('attributes[contact_name]=0', '&')
      .concat('attributes[gross_amount]=~.2f', '&')
      .concat('filters[invoices_exclude_status][]=draft', '&')
      .concat('filters[invoices_exclude_status][]=voided', '&')
      .concat('filters[invoices_exclude_status][]=deleted', '&')
      .concat('filters[invoices_status]=unpaid', '&')
      .concat('filters[type]=customer', '&')
      .concat('filters[from]=', from, '&')
      .concat('filters[to]=', to, '&')
      .concat('inverse_credit_notes_amounts=1', '&')

    exportUrl = -> "#{impacBase}/export/#{orgUid}/invoice_with_credit_note"

    vm.getInvoices = ->
      invoicesUrl = exportUrl().concat('?', paramsString())
      console.log("invoices url", invoicesUrl)
      promise = $http({
        method: 'GET',
        url: invoicesUrl,
      }).then(
        (response) ->
          # Impac! may return errors in case of empty file
          if response.data && response.data.error
            return $q.reject(response.data.error)

          anchor = angular.element('<a/>')
          anchor.css({display: 'none'}) # Make sure it's not visible
          angular.element(document.body).append(anchor) # Attach to document

          anchor.attr({
            href: 'data:attachment/csv;charset=utf-8,' + encodeURI(response.data),
            target: '_blank',
            download: 'invoice-finance.csv'
          })[0].click()

          anchor.remove() # Clean it up afterwards
          return response

        (error) ->
          return $q.reject(error)
      )

      return promise


    #====================================
    # Post-Initialization
    #====================================
    $scope.$watch(MnoeOrganizations.getSelectedId, (newValue, oldValue) ->
      MnoeCurrentUser.get().then(
        (response) ->
          selectedOrg = _.find(response.organizations, {id: parseInt(newValue)})

          orgUid = selectedOrg.uid
          fyEndMonth = selectedOrg.financial_year_end_month
          from = ImpacUtilities.financialYearDates(fyEndMonth).start
          to = ImpacUtilities.financialYearDates(fyEndMonth).end
          
          # Needs to be at least admin to display impac! or user is redirected to apps dashboard
          if MnoeOrganizations.role.atLeastAdmin(selectedOrg.current_user_role)
            # Display impac! and force it to reload if necessary
            vm.isImpacShown = true
            ImpacDashboardsSvc.reload(true) if newValue? && oldValue? && parseInt(newValue) != parseInt(oldValue)
          else
            $state.go('home.apps')
      ) if newValue?
    )

    return
