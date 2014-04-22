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
              state = document.createElement('span')
              if v == 1
                $(state).addClass("label label-danger")
                $(state).text("Failed")
              else
                $(state).addClass("label label-success")
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

    get_detail_by_sid = (s_id) ->
      alert($(this).attr('name'))
      return

  init_sidebar_profile_list()
