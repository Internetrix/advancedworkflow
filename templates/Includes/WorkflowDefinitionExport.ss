---
Name: exportedworkflow
---
Injector:
  ExportedWorkflow:
    class: WorkflowTemplate
    constructor:
	<% with ExportMetaData %>
      - '$ExportWorkflowDefName $ExportDate'
      - 'Exported from $ExportHost on $ExportDate by $ExportUser using SilverStripe versions $ExportVersionFramework'
      - 0.2
      - $ExportRemindDays
      - $ExportSort
	<% end_with %>
    properties:
      structure:
	  <% if ExportUsers %>
        users:
		<% loop ExportUsers %>
          - email: $Email
		<% end_loop %>
	  <% end_if %>
	  <% if ExportGroups %>
        groups:
		<% loop ExportGroups %>
          - title: '$Title'
		<% end_loop %>
	  <% end_if %>
	  <% if ExportActions %>
	  <% loop ExportActions %>
        '$Title':
          type: $ClassName
          <% if $ClassName == 'NotifyUsersWorkflowAction' %>
          properties:
          	<% if $EmailSubject %>
            EmailSubject: '$EmailSubject'
            <% end_if %>
            <% if $EmailFrom %>
            EmailFrom: '$EmailFrom'
            <% end_if %>
            <% if $EmailTemplate %>
            EmailTemplate: '$EmailTemplate'
            <% end_if %>
          <% else_if $ClassName == 'AssignUsersToWorkflowAction' %>
          properties:
            AssignInitiator: '$AssignInitiator'
          <% end_if %>
		  <% if Users %>
          users:
		  <% loop Users %>
            - email: $Email
		  <% end_loop %>
		  <% end_if %>
		  <% if Groups %>
          groups:
		  <% loop Groups %>
            - title: '$Title'
		  <% end_loop %>
		  <% end_if %>
		  <% if Transitions %>
          transitions:
		  <% loop Transitions %>
            - $Title: '$NextAction.Title'
		    <% if Users %>
              users:
			  <% loop Users %>
                - email: $Email
			  <% end_loop %>
		    <% end_if %>
		    <% if Groups %>
              groups:
		    <% loop Groups %>
                - title: '$Title'
		    <% end_loop %>
			<% end_if %>
		  <% end_loop %>
		  <% end_if %>
	  <% end_loop %>
	  <% end_if %>
  WorkflowService:
    properties:
      templates:
        - %\$ExportedWorkflow