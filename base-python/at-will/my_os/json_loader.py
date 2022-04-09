

import json

test_dict = {
    'bigberg': [
        7600, {
            1: [
                ['iPhone', 6300],
                ['Bike', 800],
                ['shirt', 300]
            ]
        }
    ]
}


json_str = json.dumps(test_dict)

print(json_str)
print(type(json_str))
print('json string : {}'.format(json_str))

new_dic = json.loads(json_str)
print('new dict : {}'.format(new_dic))

with open("./record.json", "w") as f:
    json.dump(new_dic, f)
    print('dump json to file {}'.format(f))
