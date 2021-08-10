const axios = require('axios')
const fs = require('fs')

const sites = {
  'https://bruh.keshsenpai.com/': {
    name: 'bruh_hub',
    '/scripts/': [
      "Arsenal",
      "Ragdoll Engine",
      "Ro-Ghoul",
      "Project Lazarus",
      "Phantom Forces",
      "Vesteria",
    ],
    '/': [
      'Library',
      'ESPs'
    ]
  }
}

Object.keys(sites).forEach(site => {
  console.log(site)
  Object.keys(sites[site]).forEach(v => {
    if (v == 'name') return
    try {
      fs.mkdirSync(v == undefined ? 'other_scripts/' : v)
    } catch{ }
    sites[site][v].forEach(c => {
      axios.request({
        url: site + v + encodeURIComponent(c) + '.lua',
        method: 'GET',
        headers: {
          "User-Agent": "Roblox/WinInet"
        }
      }).then(({ data }) => {
        try {
          fs.mkdirSync((sites[site].name == undefined ? 'other_scripts/' : sites[site].name) + v)
        } catch{}
        fs.writeFileSync((sites[site].name == undefined ? 'other_scripts/' : sites[site].name) + v + c + '.lua', data)
      }).catch(e => {
        console.log(e)
      })
    })
  })
})