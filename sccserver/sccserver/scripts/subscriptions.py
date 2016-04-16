import fitbit
from secrets import *
from tokens import *

client = fitbit.Fitbit(CLIENT_ID, CLIENT_SECRET, access_token=ACCESS_TOKEN)
