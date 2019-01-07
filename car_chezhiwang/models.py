from django.db import models

class Chezhiwang(models.Model):
    from_site = models.SmallIntegerField()
    code = models.IntegerField()
    brand = models.CharField(max_length=50, blank=True, null=True)
    title = models.CharField(max_length=100, blank=True, null=True)
    report_place = models.CharField(max_length=20, blank=True, null=True)
    demand = models.CharField(max_length=255, blank=True, null=True)
    report_time = models.DateField(blank=True, null=True)
    status = models.CharField(max_length=10, blank=True, null=True)
    car_class = models.CharField(max_length=30, blank=True, null=True)
    car_type = models.CharField(max_length=30, blank=True, null=True)
    reporter = models.CharField(max_length=30, blank=True, null=True)
    detail = models.TextField(blank=True, null=True)
    typical_fault = models.CharField(max_length=30, blank=True, null=True)
    repair_num = models.IntegerField(blank=True, null=True)
    safety_num = models.IntegerField(blank=True, null=True)
    injury_num = models.IntegerField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'chezhiwang'