EvMan.Views.OrganizedEvents ||= {}
class EvMan.Views.OrganizedEvents.PaperForm
  constructor: (container, options) ->
    @container = container
    @options = options
    @speaker_form_template = _.template(@container.find('#speaker_form_template').html())
    @speakers_container = @container.find(".speakers-container")
    @speakers = @speakers_container.data('speakers')
    @speaker_id = 0

  render: ->
    @container.find('.add-speaker-button').on('click', @newSpeakerForm)

    @renderSpeakers()
    @renderTagsSelect()
    @renderSelects()

  renderSpeakers: ->
    for speaker in @speakers
      form = new EvMan.Views.OrganizedEvents.PaperForm.SpeakerForm @speaker_form_template, ++@speaker_id, speaker
      form.render(@speakers_container)


  renderSelects: ->
    for select in @container.find('select')
      $(select).selectize()

  newSpeakerForm: =>
    form = new EvMan.Views.OrganizedEvents.PaperForm.SpeakerForm(@speaker_form_template, ++@speaker_id)
    form.render(@speakers_container)

  renderTagsSelect: ->
    @taggeds_form = new EvMan.Views.Taggeds.Form(@container, { select_selector: '#organized_event_paper_tag_names' })
    @taggeds_form.render()

class EvMan.Views.OrganizedEvents.PaperForm.SpeakerForm
  constructor: (template, id, speaker) ->
    @template = template
    @id = id
    @speaker = speaker || {}

  render: (placement) ->
    @container = $(@template({id: @id}))
    # Email
    @container.find('.field-email').selectize
      valueField: 'email'
      labelField: 'label'
      create: true
      options: [@speaker]
    @container.find('.field-email')[0].selectize.setValue(@speaker.email)

    # T-shirt size
    @container.find('.field-tshirt_size_id').selectize()
    @container.find('.field-tshirt_size_id')[0].selectize.setValue(@speaker.tshirt_size_id)

    # Primary
    $.evman.globalRender(@container)
    @container.find('.field-primary').iCheck(if @speaker.primary then 'check' else 'uncheck')

    # Remove
    @container.find('.remove-button').on 'click', =>
      @container.remove()

    placement.append(@container)