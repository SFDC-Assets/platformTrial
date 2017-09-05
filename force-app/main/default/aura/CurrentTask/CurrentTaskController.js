({
	stepChange: function (component, event, helper) {
		console.log("stepChanged");
		component.find("stepRec").reloadRecord();
		helper.loadPopovers(component);
	},

	fullReload: function (component, event, helper) {
		console.log("fullReload");
		component.find("trialRec").reloadRecord();
		component.find("stepRec").reloadRecord();
	},

	vid: function (component, event, helper) {
		console.log(event.getSource().get("v.value"));
		var nav = $A.get("e.force:navigateToComponent");
		nav.setParams({
			componentDef: "c:youtubeVideoComponent",
			componentAttributes: {
				videoId: component.get("v.stepFields." + event.getSource().get("v.value"))
			}
		});
		nav.fire();
	},

	doInit: function (component, event, helper) {
		var action = component.get("c.getTrialActivityId");
		action.setStorable();
		action.setCallback(this, function (a) {
			var state = a.getState();
			if (state === "SUCCESS") {
				var rec = component.find("trialRec");
				rec.set("v.recordId", a.getReturnValue());
				rec.reloadRecord();

			} else if (state === "ERROR") {
				console.log(a.getError());
			}
		});
		$A.enqueueAction(action);

		//fire an event to let everyone know that it's open

		var msg = $A.get("e.ltng:sendMessage");
		console.log("message:"); console.log(msg);
		msg.setParams({"message" : "CurrentTaskOpened", "channel" : "trialMessages"});
		msg.fire();

	},

})