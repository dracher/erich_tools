$ ->
  init_sidebar_profile_list = () ->
    $.get('/data/profile/all',
    (data) ->
      s_list = $("#sidebar_profile_list")
      s_list.empty()
      for i in data['ret']
        p = i['profile']
        tmp = document.createElement("a")
        $(tmp).addClass("btn btn-default")
        $(tmp).attr("name", "#{p}")
        $(tmp).text("#{p}")
        $(tmp).bind('click',
        () ->
          get_profile_by_name($(this).attr("name"))
        )
        s_list.append(tmp)
      return
    )
    return

  get_profile_by_name = (name) ->
    $.get("/data/profile/by/#{name}",
    (data) ->
      ret = data['ret']
      top = $("#main_tbody")
      top.empty()
      for l in ret
        row = document.createElement("tr")
        for k, v of l
          td = document.createElement("td")
          if k == "state"
            state = document.createElement('button')
            if v == 1
              $(state).addClass("btn btn-danger")
              $(state).text("Failed")
            else
              $(state).addClass("btn btn-success btn-sm")
              $(state).text("Passed")
            $(state).attr("name", l['session_id'])
            $(state).bind('click', get_detail_by_sid)
            $(td).append(state)
          else if k == "additional_kargs"
            s_kargs = v.slice(0, 40)
            kargs = "<abbr title=\"#{v}\">#{s_kargs}</abbr>"
            $(td).append(kargs)
          else
            $(td).text(v)
          $(row).append(td)
        top.append(row)
    )

    insert_row_into_table = (start, len, data, s_id) ->
      tb = document.getElementById('main_tbody')
      rh = tb.insertRow(start)
      $(rh).addClass("info #{s_id}_exp")
      for t in ['JobId', 'CaseName', 'Result', 'Bugzilla ID', 'Detail']
        ch = rh.insertCell(-1)
        ch.innerHTML = "<span style='font-weight: bold'>#{t}</span>"
      for i in [(start + 1)..(start + len)]
        r = tb.insertRow(i)
        $(r).addClass("info #{s_id}_exp")
        d_ = data.shift()
        for k, v of d_
          if k == 'annotations' and v != ''
            c = r.insertCell(-1)
            ary = v.split(',')
            s = ""
            for url in ary
              s += "<a href=\"http://bugzilla.redhat.com/show_bug.cgi?id=#{v}\" target=\"_blank\">#{v}</a>"
            c.innerHTML = s
          else
            c = r.insertCell(-1)
            c.innerHTML = v
        c = r.insertCell(-1)
        btn = document.createElement('a')
        $(btn).addClass("btn btn-default btn-sm")
        name = d_['testcase']

        $(btn).attr('href', "/data/log/by/#{s_id}/#{name}")
        $(btn).attr('target', '_blank')
        $(btn).text("Full Log")
        $(c).append(btn)


    get_detail_by_sid = () ->
      s_id = $(this).attr('name')
      if !$(".#{s_id}_exp").length
        s_index = $(this.parentNode.parentNode).index() + 1
        $.get("/data/details/by/#{s_id}",
          (data) ->
            ret = data['ret']
            insert_row_into_table(s_index, ret.length, ret, s_id)
        )
      else
        $(".#{s_id}_exp").remove()

  init_sidebar_profile_list()
