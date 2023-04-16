class UserPlan {
  List<Subscription>? subscriptions;

  UserPlan({this.subscriptions});

  factory UserPlan.fromJson(Map<String, dynamic> json) {
    return UserPlan(
      subscriptions: json['subscriptions'] != null ? (json['subscriptions'] as List).map((i) => Subscription.fromJson(i)).toList() : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.subscriptions != null) {
      data['subscriptions'] = this.subscriptions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Subscription {
  String? subscriptionPlanId;
  String? startDate;
  String? expirationDate;
  String? status;
  String? trailStatus;
  String? subscriptionPlanName;
  String? billingAmount;
  String? trialEnd;

  Subscription({
    this.subscriptionPlanId,
    this.startDate,
    this.expirationDate,
    this.status,
    this.trailStatus,
    this.subscriptionPlanName,
    this.billingAmount,
    this.trialEnd,
  });

  factory Subscription.fromJson(Map<String, dynamic> json) {
    return Subscription(
      subscriptionPlanId: json['subscription_plan_id'],
      startDate: json['start_date'],
      expirationDate: json['expiration_date'],
      status: json['status'],
      trailStatus: json['trail_status'],
      subscriptionPlanName: json['subscription_plan_name'],
      billingAmount: json['billing_amount'],
      trialEnd: json['trial_end'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['subscription_plan_id'] = this.subscriptionPlanId;
    data['start_date'] = this.startDate;
    data['expiration_date'] = this.expirationDate;
    data['status'] = this.status;
    data['trail_status'] = this.trailStatus;
    data['subscription_plan_name'] = this.subscriptionPlanName;
    data['billing_amount'] = this.billingAmount;
    data['trial_end'] = this.trialEnd;
    return data;
  }
}
