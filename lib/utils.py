import yaml
import os

module_dir = os.path.dirname(__file__)  # Get the directory where module.py is located
apikeys = os.path.join(module_dir, '..', 'configs', 'api_keys.yml')

keys = dict()
url = dict()

with open(os.path.abspath(apikeys), 'r') as conf:
    config = yaml.safe_load(conf)
    keys['cgk'] = config['coingecko_key']
    keys['cgk_rate_lim'] = config['coingecko_rate_limit']
    keys['infr'] = config['infura']

    url['cgk'] = config['coingecko_base_url']
    url['infura'] = config['infura_base_url'] + config['infura'] + '/'

