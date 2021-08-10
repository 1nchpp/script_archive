const axios = require('axios')
const fs = require('fs')

const sites = {
  'https://bruh.keshsenpai.com/': {
    name: 'bruh_hub/',
    'scripts/': [
      "Arsenal",
      "Ragdoll Engine",
      "Ro-Ghoul",
      "Project Lazarus",
      "Phantom Forces",
      "Vesteria",
    ],
    '': [
      'Library',
      'ESPs'
    ]
  }
}

Object.keys(sites).forEach(site => {
  console.log(site)
  Object.keys(sites[site]).forEach(v => {
    if (v == 'name') return
    sites[site][v].forEach(c => {
      axios.request({
        url: site + v + encodeURIComponent(c) + '.lua',
        method: 'GET',
        headers: {
          "User-Agent": "Roblox/WinInet"
        }
      }).then(({ data }) => {
        try{fs.mkdirSync(sites[site].name == undefined ? 'other_scripts/' : sites[site].name)}catch{}
        fs.writeFileSync((sites[site].name == undefined ? 'other_scripts/' : sites[site].name) + c + '.lua', data)
      }).catch(e => {
        console.log(e)
      })
    })
  })
})