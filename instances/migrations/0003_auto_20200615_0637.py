# Generated by Django 2.2.13 on 2020-06-15 06:37

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('instances', '0002_permissionset'),
    ]

    operations = [
        migrations.AlterField(
            model_name='instance',
            name='created',
            field=models.DateField(auto_now_add=True, verbose_name='created'),
        ),
        migrations.AlterField(
            model_name='instance',
            name='is_template',
            field=models.BooleanField(default=False, verbose_name='is template'),
        ),
        migrations.AlterField(
            model_name='instance',
            name='name',
            field=models.CharField(max_length=120, verbose_name='name'),
        ),
        migrations.AlterField(
            model_name='instance',
            name='uuid',
            field=models.CharField(max_length=36, verbose_name='uuid'),
        ),
    ]